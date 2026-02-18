import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_extension/model/multi_body.dart';
import 'package:flutter_extension/model/user.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class UserController extends GetxController {
  final userInfo = Rxn<User>();
  final api = ApiService();
  final RxnString privacyPolicy = RxnString();
  final RxnString aboutUs = RxnString();
  final RxInt unreadNotifications = RxInt(0);
  final notificationRefreshTime = Duration(minutes: 10);

  RxBool isLoading = RxBool(false);
  final RxBool isSubscribed = false.obs;

  Future<String> getInfo() async {
    isLoading.value = true;
    try {
      final response = await api.get(ApiConstant.profileDetails, authReq: true);
      var body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setInfo(body['data']);
        isLoading.value = false;
        return "success";
      } else {
        isLoading.value = false;
        return body['message'] ?? "Connection Error";
      }
    } catch (e) {
      isLoading.value = false;
      return "Unexpected error: ${e.toString()}";
    }
  }

  void setInfo(Map<String, dynamic>? json) {
    if (json != null) {
      userInfo.value = User.fromJson(json);
      debugPrint("User Info:====> $json");
    }
  }

  Future<String> updateInfo({String? name, String? phone, File? image}) async {
    isLoading.value = true;
    try {
      name ??= userInfo.value!.fullName;
      phone ??= userInfo.value!.phone;
      final body = {"name": name, "phone": phone};

      // Files go here
      final multipartBody = <MultipartBody>[];
      if (image != null) {
        multipartBody.add(MultipartBody(key: "avatar", file: image));
      }

      final response = await api.patchMultipartData(
        "/profile/edit",
        body,
        authReq: true,
        multipartBody: multipartBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        setInfo(body['data']);
        isLoading.value = false;
        return "success";
      }
      return "Connection Error";
    } catch (e) {
      debugPrint("Error: $e");
      return "Unexpected error: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  void getContext(String endpoint) async {
    isLoading.value = true;
    try {
      final response = await api.get("/context-pages/$endpoint");
      var body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        aboutUs.value = body['data'];
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String? getImageUrl() {
    if (userInfo.value == null || userInfo.value!.profilePic.isEmpty) {
      return null;
    }

    String baseUrl = api.imageUrl;

    return baseUrl + userInfo.value!.profilePic;
  }

  String? addBaseUrl(String image) {
    if (image.isEmpty) {
      return null;
    }

    String baseUrl = api.imageUrl;
    return baseUrl + image;
  }
}
