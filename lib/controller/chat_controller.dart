import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_extension/model/chat_model.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final ApiService _apiService = ApiService();

  RxBool isLoading = false.obs;

  RxList<ChatThreadModel> chatList = <ChatThreadModel>[].obs;
  RxList<ChatThreadModel> filteredList = <ChatThreadModel>[].obs;

  final searchQuery = ''.obs;

  @override
  void onInit() {
    ever(searchQuery, (_) => _filterChats());
    super.onInit();
  }

  Future<void> getChatList() async {
    isLoading.value = true;

    try {
      final response = await _apiService.get(
        ApiConstant.threadList,
        authReq: true,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List dataList = body['data'] ?? [];

        final chats = dataList.map((e) => ChatThreadModel.fromJson(e)).toList();

        chatList.assignAll(chats);
        filteredList.assignAll(chats);
      }
    } catch (e) {
      debugPrint("Error: $e");
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
        final lastMessage = (chat.lastMessage?.content ?? '').toLowerCase();

        return name.contains(query) || lastMessage.contains(query);
      }).toList(),
    );
  }

  Future<void> refreshChats() async {
    await getChatList();
  }
}
