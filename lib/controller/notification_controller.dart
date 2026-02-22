import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_extension/model/notification_model.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final ApiService _apiService = ApiService();

  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchNotifications() async {
    isLoading.value = true;

    try {
      final response = await _apiService.get(
        ApiConstant.notification,
        authReq: true,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List dataList = body['data'] ?? [];

        notifications.value = dataList
            .map((e) => NotificationModel.fromJson(e))
            .toList();
      } else {
        notifications.clear();
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
