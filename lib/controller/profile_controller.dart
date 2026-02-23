import 'package:flutter/material.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:get/get.dart';
import 'dart:convert';

class ProfileController extends GetxController {
  final ApiService _apiService = ApiService();

  RxBool isLoading = false.obs;

  RxString privacyHtml = ''.obs;

  Future<void> getPrivacyPolicy() async {
    isLoading.value = true;

    try {
      final response = await _apiService.get(
        ApiConstant.privacyPolicy,
        authReq: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);

        privacyHtml.value = body['data']?['description'];
      }
    } catch (e) {
      privacyHtml.value = '';
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
