import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_extension/model/chat_model.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  final ApiService _apiService = ApiService();
  RxBool isLoading = false.obs;
  RxBool isLiked = false.obs;
  RxInt selectedReasonIndex = (-1).obs;

  RxList<ChatThreadModel> chatList = <ChatThreadModel>[].obs;

  RxList<dynamic> reasons = [
    "Harassment or bullying",
    "Offensive content",
    "Technical problem",
    "Other issues",
  ].obs;

  void reasonSelect(int index) {
    selectedReasonIndex.value = index;
  }

  String? get selectedReason {
    if (selectedReasonIndex.value == -1) return null;
    return reasons[selectedReasonIndex.value];
  }

  Future<void> toggleLike(int id) async {
    final previousState = isLiked.value;

    isLiked.value = !previousState;

    bool success;
    if (isLiked.value) {
      success = await likePost(id);
    } else {
      success = await unlikePost(id);
    }
    if (!success) {
      isLiked.value = previousState;
    }
  }

  Future<bool> likePost(int id) async {
    isLoading.value = true;
    try {
      final response = await _apiService.post(
        "account/user/$id/like/",
        {},
        authReq: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> unlikePost(int id) async {
    isLoading.value = true;
    try {
      final response = await _apiService.post(
        "account/user/$id/unlike/",
        {},
        authReq: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void blockUser(String id) async {
    isLoading.value = true;
    try {
      final response = await _apiService.post(ApiConstant.mutualSystemBlock, {
        "blocked_user_id": id,
      }, authReq: true);
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("User blocked successfully", isError: false);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void reportUser(String id) async {
    isLoading.value = true;
    try {
      if (selectedReasonIndex.value == -1) {
        Get.snackbar("Error", "Please select a reason");
        return;
      }
      final response = await _apiService.post(ApiConstant.mutualSystemReports, {
        "reported_user": id.toString(),
        "reason": reasons[selectedReasonIndex.value],
        "comment": "",
      }, authReq: true);
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("User reported successfully", isError: false);
        return;
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createThread(int id) async {
    isLoading.value = true;
    try {
      final response = await _apiService.post(ApiConstant.createThreads, {
        "other_user_id": id,
      }, authReq: true);
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = body['data'] ?? <String, dynamic>{};

        chatList.add(ChatThreadModel.fromJson(data));

        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
