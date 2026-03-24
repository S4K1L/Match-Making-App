import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user_controller.dart';
import 'package:flutter_extension/model/multi_body.dart';
import 'package:flutter_extension/model/like_you_model.dart';
import 'package:flutter_extension/model/society_chat_model.dart';
import 'package:flutter_extension/model/society_model.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/services/media_service.dart';
import 'package:flutter_extension/services/shared_prefs_service.dart';
import 'package:flutter_extension/services/websocket_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SocietyController extends GetxController {
  final ApiService _apiService = ApiService();

  RxBool isLoading = false.obs;

  final ImagePicker picker = ImagePicker();
  final Rxn<XFile> profileImage = Rxn<XFile>();

  RxList<SocietyModel> societyList = <SocietyModel>[].obs;
  RxList<SocietyChatModel> societyChats = <SocietyChatModel>[].obs;
  RxList<LikeYouModel> societyMembers = <LikeYouModel>[].obs;

  final TextEditingController societyNameController = TextEditingController();

  int? activeSocietyId;

  Future<void> initSocietyChat(int societyId) async {
    activeSocietyId = societyId;

    await _connectSocket(societyId);
    await getSocietyMembers(societyId);
    await getAllSocietyMessages(societyId);

    WebSocketService.on("message", _handleIncomingMessage);
  }

  void disposeSocietyChat() {
    activeSocietyId = null;
    societyMembers.clear();
    WebSocketService.off("message");
    WebSocketService.disconnect();
  }

  Future<void> _connectSocket(int societyId) async {
    final token = await SharedPrefsService.get('token');

    await WebSocketService.connect(
      id: societyId.toString(),
      token: token!,
      isSociety: true,
    );
  }

  void _handleIncomingMessage(dynamic data) {
    final msg = SocietyChatModel.fromJson(data);

    if (!societyChats.any((m) => m.id == msg.id)) {
      societyChats.add(msg);
    }
  }

  void sendSocietyMessage(String message) {
    if (activeSocietyId == null) return;

    final myId = Get.find<UserController>().userInfo.value!.userId;
    final temp = SocietyChatModel(
      id: DateTime.now().millisecondsSinceEpoch,
      society: activeSocietyId!,
      sender: Sender(
        userId: myId,
        email: '',
        username: '',
        fullName: '',
        profilePic: null,
        isOnline: true,
      ),
      content: message,
      messageType: "text",
      attachment: null,
      createdAt: DateTime.now(),
    );

    societyChats.add(temp);

    final payload = {
      "type": "message.send",
      "payload": {"content": message, "attachment": null},
    };

    WebSocketService.send(payload);
  }

  Future<void> getAllSociety() async {
    isLoading.value = true;
    try {
      final response = await _apiService.get(
        ApiConstant.societyList,
        authReq: true,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = body['data'] ?? [];

        societyList.assignAll(
          data.map((e) => SocietyModel.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllSocietyMessages(int societyId) async {
    isLoading.value = true;

    try {
      final response = await _apiService.get(
        "chat/societies/$societyId/messages/",
        authReq: true,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = body['data'] ?? [];

        societyChats.assignAll(
          data.map((e) => SocietyChatModel.fromJson(e)).toList(),
        );
        _mergeMembersFromMessages();
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSocietyMembers(int societyId) async {
    try {
      final response = await _apiService.get(
        "chat/societies/$societyId/members/",
        authReq: true,
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = body['data'] ?? [];
        societyMembers.assignAll(
          data.map((e) => LikeYouModel.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      debugPrint("Error fetching society members: $e");
    }
  }

  Future<void> createSociety() async {
    isLoading.value = true;

    try {
      if (profileImage.value == null) {
        isLoading.value = false;
        showCustomSnackBar("Please select an image", isError: true);
        return;
      }

      if (societyNameController.text.isEmpty) {
        isLoading.value = false;
        showCustomSnackBar("Please enter society name", isError: true);
        return;
      }

      final response = await _apiService.postMultipartData(
        ApiConstant.createSociety,
        {"name": societyNameController.text},
        authReq: true,
        multipartBody: [
          MultipartBody(key: "image", file: File(profileImage.value!.path)),
        ],
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Society created successfully", isError: false);

        Get.back();
        getAllSociety();
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      profileImage.value = picked;
    }
  }

  Future<void> sendSocietyImageMessage(
    int societyId, {
    required ImageSource source,
  }) async {
    try {
      final image = await picker.pickImage(source: source);
      if (image == null) return;

      final myId = Get.find<UserController>().userInfo.value!.userId;

      /// ✅ TEMP MESSAGE (NO LOCAL IMAGE)
      final temp = SocietyChatModel(
        id: DateTime.now().millisecondsSinceEpoch,
        society: societyId,
        sender: Sender(
          userId: myId,
          email: '',
          username: '',
          fullName: '',
          profilePic: null,
          isOnline: true,
        ),
        content: "",
        messageType: "image",
        attachment: null,
        createdAt: DateTime.now(),
        isUploading: true,
      );

      societyChats.add(temp);

      final data = await MediaService.sendSocietyImageMessage(
        societyId: societyId,
        file: image,
      );

      final realMessage = SocietyChatModel.fromJson(data);

      _replaceTempMessage(temp.id, realMessage);
    } catch (e) {
      debugPrint("Society image send error: $e");

      /// mark failed
      // _markMessageFailed(temp.id);
    }
  }

  void _replaceTempMessage(int tempId, SocietyChatModel newMessage) {
    final index = societyChats.indexWhere((m) => m.id == tempId);

    if (index != -1) {
      societyChats[index] = newMessage;
      _mergeMembersFromMessages();
    }
  }

  void _mergeMembersFromMessages() {
    if (societyChats.isEmpty) return;

    final existingIds = societyMembers.map((m) => m.userId).toSet();
    final senderMap = <int, LikeYouModel>{};

    for (final chat in societyChats) {
      final sender = chat.sender;
      if (sender == null) continue;
      if (existingIds.contains(sender.userId)) continue;

      senderMap[sender.userId] = LikeYouModel(
        userId: sender.userId,
        username: sender.username,
        fullName: sender.fullName,
        isOnline: sender.isOnline,
        profilePic: sender.profilePic,
        hobbies: const [],
        distance: null,
      );
    }

    if (senderMap.isNotEmpty) {
      societyMembers.addAll(senderMap.values.toList());
    }
  }
}
