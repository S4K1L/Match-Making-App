import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_extension/model/like_you_model.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:get/get.dart';

class LikeYouController extends GetxController {
  final ApiService _apiService = ApiService();

  RxBool isLoading = false.obs;

  final TextEditingController searchController = TextEditingController();

  RxList<LikeYouModel> likeYouList = <LikeYouModel>[].obs;
  RxList<LikeYouModel> originalList = <LikeYouModel>[].obs;
  RxSet<String> selectedUserIds = <String>{}.obs;

  var selectedGender = ''.obs;
  RxDouble distance = 60.0.obs;
  final min = 18.0, max = 100.0;
  var rv = const RangeValues(18, 32).obs;

  Timer? _debounce;

  List<String> getSelectedUserIds() {
    return selectedUserIds.toList();
  }

  void toggleUserSelection(String id) {
    if (selectedUserIds.contains(id)) {
      selectedUserIds.remove(id);
    } else {
      selectedUserIds.add(id);
    }
  }

  bool isUserSelected(String id) {
    return selectedUserIds.contains(id);
  }

  void clearSelection() {
    selectedUserIds.clear();
  }

  Future<void> addMemebersToSociety(int societyId) async {
    isLoading.value = true;
    try {
      final response = await _apiService.post(
        "chat/societies/$societyId/members/",
        {"user_ids": getSelectedUserIds()},
        authReq: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          "Society members added successfully",
          isError: false,
        );
        Get.back();
      } else {
        showCustomSnackBar("Please try again", isError: true);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (value.trim().isEmpty) {
        likeYouList.assignAll(originalList);
      } else {
        searchUser(value);
      }
    });
  }

  Future<void> searchUser(String query) async {
    isLoading.value = true;

    try {
      final response = await _apiService.get(
        "account/users/search/?q=$query",
        authReq: true,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = body['data'] ?? [];

        likeYouList.assignAll(
          data.map((e) => LikeYouModel.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      debugPrint("Search Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> filterUser() async {
    isLoading.value = true;
    likeYouList.clear();

    try {
      final query = buildQuery(
        gender: selectedGender.value,
        minAge: rv.value.start.round(),
        maxAge: rv.value.end.round(),
        distance: distance.value,
      );

      final uri = Uri.parse(
        "account/users/filter/",
      ).replace(queryParameters: query);

      final response = await _apiService.get(uri.toString(), authReq: true);

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = body['data'] ?? [];

        likeYouList.assignAll(
          data.map((e) => LikeYouModel.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      debugPrint("Filter Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, String> buildQuery({
    String? gender,
    int? minAge,
    int? maxAge,
    double? distance,
  }) {
    final map = <String, String>{};

    if (gender != null && gender.isNotEmpty) {
      map['gender'] = gender;
    }

    if (minAge != null) {
      map['min_age'] = minAge.toString();
    }

    if (maxAge != null) {
      map['max_age'] = maxAge.toString();
    }

    if (distance != null && distance != double.infinity) {
      map['max_distance'] = distance.round().toString();
    }

    return map;
  }

  void resetFilters() {
    selectedGender.value = '';
    distance.value = 60.0;
    rv.value = const RangeValues(18, 32);
    getAllLikeYou();
  }

  Future<void> getAllLikeYou() async {
    isLoading.value = true;

    try {
      final response = await _apiService.get(
        ApiConstant.whoLikedMe,
        authReq: true,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = body['data'] ?? [];

        final list = data.map((e) => LikeYouModel.fromJson(e)).toList();

        likeYouList.assignAll(list);
        originalList.assignAll(list);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void setRange(double start, double end) {
    rv.value = RangeValues(start, end);
  }

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  void setDistance(double value) {
    distance.value = value;
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
