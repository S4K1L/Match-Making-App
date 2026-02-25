import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user_controller.dart';
import 'package:flutter_extension/model/chat_model.dart';
import 'package:flutter_extension/model/message_model.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/services/media_service.dart';
import 'package:flutter_extension/services/shared_prefs_service.dart';
import 'package:flutter_extension/services/websocket_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  final ApiService _apiService = ApiService();

  RxBool isLoading = false.obs;
  RxBool isUploading = false.obs;

  RxList<ChatMessage> messageList = <ChatMessage>[].obs;
  RxList<ChatThreadModel> chatList = <ChatThreadModel>[].obs;
  RxList<ChatThreadModel> filteredList = <ChatThreadModel>[].obs;

  final searchQuery = ''.obs;

  int? activeThreadId;

  @override
  void onInit() {
    ever(searchQuery, (_) => _filterChats());
    super.onInit();
  }

  // ================= CHAT LIFECYCLE =================

  Future<void> initChat(int threadId) async {
    activeThreadId = threadId;

    await _connectSocket(threadId);
    await getAllMessages(threadId);

    WebSocketService.on("message", _handleIncomingMessage);
  }

  void disposeChat() {
    activeThreadId = null;
    WebSocketService.off("message");
    WebSocketService.disconnect();
  }

  Future<void> _connectSocket(int threadId) async {
    final token = await SharedPrefsService.get('token');

    await WebSocketService.connect(
      id: threadId.toString(),
      token: token!,
      isSociety: false,
    );
  }

  // ================= SOCKET =================

  void _handleIncomingMessage(dynamic data) {
    final msg = ChatMessage.fromJson(data);

    // Remove matching temp messages
    messageList.removeWhere(
      (m) =>
          m.isUploading == true &&
          m.messageType == msg.messageType &&
          m.thread == msg.thread,
    );

    // Prevent duplicate
    if (!messageList.any((m) => m.messageId == msg.messageId)) {
      messageList.add(msg);
    }
  }

  // ================= FETCH =================

  Future<void> getAllMessages(int threadId) async {
    isLoading.value = true;

    try {
      final response = await _apiService.get(
        "chat/messages/?thread=$threadId",
        authReq: true,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List data = body['data'] ?? [];

        messageList.assignAll(
          data.map((e) => ChatMessage.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      debugPrint("Fetch messages error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void sendTextMessage(int threadId, String message) {
    final myId = Get.find<UserController>().userInfo.value!.userId;

    final temp = ChatMessage.local(
      thread: threadId,
      myId: myId,
      content: message,
      messageType: "text",
    );

    _addTempMessage(temp);

    WebSocketService.sendText(thread: threadId, message: message);
  }

  Future<void> sendImageMessage(
    int threadId, {
    required ImageSource source,
  }) async {
    try {
      final image = await MediaService.pickImage(source);
      if (image == null) return;

      final myId = Get.find<UserController>().userInfo.value!.userId;

      final temp = ChatMessage.local(
        thread: threadId,
        myId: myId,
        localPath: image.path,
        messageType: "image",
      );

      messageList.add(temp);

      final data = await MediaService.sendImageMessage(
        threadId: threadId,
        file: image,
      );

      final realMessage = ChatMessage.fromJson(data);

      _replaceTempMessage(temp.messageId, realMessage);
    } catch (e) {
      debugPrint("Image send error: $e");
      _markMessageFailed();
    }
  }

  void _replaceTempMessage(int tempId, ChatMessage newMessage) {
    final index = messageList.indexWhere((m) => m.messageId == tempId);

    if (index != -1) {
      messageList[index] = newMessage;
    }
  }

  void _markMessageFailed() {
    if (messageList.isEmpty) return;

    final last = messageList.last;

    if (last.isUploading == true) {
      messageList.last = last.copyWith(isUploading: false, isFailed: true);
    }
  }

  void _addTempMessage(ChatMessage msg) {
    messageList.add(msg);
  }

  Future<void> getChatList() async {
    isLoading.value = true;

    try {
      final response = await _apiService.get(
        ApiConstant.threadList,
        authReq: true,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List data = body['data'] ?? [];

        final chats = data.map((e) => ChatThreadModel.fromJson(e)).toList();

        chatList.assignAll(chats);
        filteredList.assignAll(chats);
      }
    } catch (e) {
      debugPrint("Chat list error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _filterChats() {
    final query = searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      filteredList.assignAll(chatList);
      return;
    }

    filteredList.assignAll(
      chatList.where((chat) {
        final name = chat.otherUser?.fullName?.toLowerCase() ?? '';
        final lastMsg = (chat.lastMessage?.content ?? '').toLowerCase();

        return name.contains(query) || lastMsg.contains(query);
      }).toList(),
    );
  }

  Future<void> refreshChats() async {
    await getChatList();
  }
}
