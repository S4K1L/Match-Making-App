import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList notifications = [].obs;
  RxBool isLoading = false.obs;

  void fetchNotifications() async {
    isLoading.value = true;
    try {
      final response = await _apiService.get(
        ApiConstant.notification,
        authReq: true,
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final list = (body['data'] as List).map((e) => e).toList();
        notifications.value = list;
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
