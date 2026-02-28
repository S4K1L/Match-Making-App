import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_extension/model/multi_body.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_extension/util/image_utils.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/home/AllSubScreen/add_story_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/my_story_model.dart';

class MyStoryController extends GetxController {
  final ApiService _apiService = ApiService();

  final Rx<File?> pickedStory = Rx<File?>(null);

  final RxList<MyStoryModel> myStories = <MyStoryModel>[].obs;

  final currentIndex = 0.obs;
  final progress = 0.0.obs;
  final isLoading = false.obs;
  RxBool isViewerLoading = false.obs;

  final showViewers = false.obs;

  RxInt totalViewers = 0.obs;

  MyStoryModel? get currentStory =>
      myStories.isEmpty ? null : myStories[currentIndex.value];

  Timer? _timer;

  void startProgress() {
    if (myStories.isEmpty) return;

    _timer?.cancel();

    progress.value = 0.0;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (progress.value >= 1.0) {
        t.cancel();
        nextStory();
        return;
      }

      progress.value += 0.01;
    });
  }

  void stopProgress() {
    _timer?.cancel();
  }

  void nextStory() {
    if (myStories.isEmpty) return;

    _timer?.cancel();

    currentIndex.value = (currentIndex.value + 1) % myStories.length;

    progress.value = 0.0;

    Future.microtask(() {
      startProgress();
    });
  }

  void prevStory() {
    if (myStories.isEmpty) return;

    _timer?.cancel();

    currentIndex.value = (currentIndex.value - 1) < 0
        ? myStories.length - 1
        : currentIndex.value - 1;

    progress.value = 0.0;

    startProgress();
  }

  void openViewers() {
    showViewers.value = true;
    stopProgress();
  }

  void closeViewers() {
    showViewers.value = false;
    startProgress();
  }

  Future<void> pickAddStoryImage({bool fromCamera = false}) async {
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );

    if (pickedFile != null) {
      Get.to(() => AddStoryScreen(imagePath: pickedFile.path));
    }
  }

  Future<void> createStory(List<XFile> files) async {
    isLoading.value = true;

    try {
      final multipartList = files
          .map((file) => MultipartBody(key: "media", file: File(file.path)))
          .toList();

      final response = await _apiService.postMultipartData(
        ApiConstant.mutualSystemCreateStory,
        {},
        multipartBody: multipartList,
        authReq: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Story created successfully", isError: false);
        Get.back();
      } else {
        showCustomSnackBar("Try again later", isError: true);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getStories() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        ApiConstant.mutualSystemMyStory,
        authReq: true,
      );

      if (!_isSuccess(response.statusCode)) {
        myStories.clear();
        return;
      }

      final body = jsonDecode(response.body);

      final List data = (body['data'] as List?) ?? [];

      final stories = data
          .map((e) => MyStoryModel.fromJson(e))
          .where(_isValidStory)
          .toList();

      myStories.assignAll(stories);

      _resetAndStart();
    } catch (e) {
      debugPrint("Story Error: $e");
      myStories.clear();
    } finally {
      isLoading.value = false;
    }
  }

  bool _isSuccess(int code) => code == 200 || code == 201;

  bool _isValidStory(MyStoryModel story) {
    final hasContent = story.media != null || story.text != null;
    final notExpired = DateTime.now().isBefore(story.expiresAt);
    return hasContent && notExpired;
  }

  void _resetAndStart() {
    currentIndex.value = 0;
    progress.value = 0.0;

    if (myStories.isNotEmpty) {
      startProgress();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
