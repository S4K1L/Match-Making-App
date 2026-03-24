import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_extension/model/global_story_model.dart';
import 'package:flutter_extension/model/multi_body.dart';
import 'package:flutter_extension/model/mutual_story_list_model.dart';
import 'package:flutter_extension/model/story_model.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  RxList<GlobalStoryModel> globalStories = <GlobalStoryModel>[].obs;
  RxList<MutualStoryModel> mutualStories = <MutualStoryModel>[].obs;
  Rxn<StoryModel> myStory = Rxn<StoryModel>();

  RxBool isLoading = false.obs;

  RxInt currentIndex = 0.obs;
  RxInt currentImageIndex = 0.obs;

  RxDouble progressValue = 0.0.obs;
  RxDouble dragDx = 0.0.obs;

  Timer? timer;
  bool isAnimatingOut = false;

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchData();
  // }

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      await Future.wait([
        fetchGlobalStories(),
        fetchMutualStories(),
        fetchMyStories(),
      ]);

      if (globalStories.isNotEmpty) {
        _resetStoryState();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _resetStoryState() {
    currentIndex.value = 0;
    currentImageIndex.value = 0;

    _preloadCurrent();
    _preloadNext();

    startProgress();
  }

  Future<void> fetchGlobalStories() async {
    final response = await _apiService.get(
      ApiConstant.globalFeed,
      authReq: true,
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      globalStories.value = (body['data']['results'] as List)
          .where((e) => e['pop_images'] is List && e['pop_images'].isNotEmpty)
          .map((e) => GlobalStoryModel.fromJson(e))
          .toList();
    }
  }

  Future<void> fetchMutualStories() async {
    final response = await _apiService.get(
      ApiConstant.mutualSystemGlobalStory,
      authReq: true,
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List dataList = body['data'] ?? [];

      mutualStories.value = dataList
          .map((e) => MutualStoryModel.fromJson(e))
          .toList();
    } else {
      mutualStories.clear();
    }
  }

  Future<void> fetchMyStories() async {
    final response = await _apiService.get(
      ApiConstant.mutualSystemMyStory,
      authReq: true,
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List dataList = body['data'] ?? [];

      if (dataList.isEmpty) {
        myStory.value = null;
        return;
      }

      final list = dataList.map((e) => MutualStoryModel.fromJson(e)).toList();

      final mediaPaths = list
          .where((e) => e.media != null && e.media!.isNotEmpty)
          .map((e) => "${ApiConstant.BASE_URL_IMAGE}${e.media}")
          .toList();

      myStory.value = StoryModel(
        id: list.first.id,
        userName: list.first.fullName ?? "You",
        mediaPaths: mediaPaths,
        isMe: true,
        createdAt: list.first.createdAt,
        expiresAt: list.first.expiresAt,
      );
    } else {
      myStory.value = null;
    }
  }

  Future<void> pickImage() async {
    final files = await _picker.pickMultiImage(imageQuality: 85);
    if (files.isEmpty) return;

    await createStory(files);

    _resetStoryState();
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

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        myStory.value = StoryModel(
          id: body['data']['id'],
          userName: "You",
          mediaPaths: files.map((e) => e.path).toList(),
          isMe: true,
        );

        await fetchMyStories();
        await fetchMutualStories();

        Get.back();
      } else {
        showCustomSnackBar("Try again later", isError: true);
      }
    } finally {
      isLoading.value = false;
    }
  }

  List<String> getCurrentImages() {
    if (globalStories.isEmpty || currentIndex.value >= globalStories.length) {
      return [];
    }

    return globalStories[currentIndex.value].popImages
            ?.map((e) => e.imageUrl ?? "")
            .toList() ??
        [];
  }

  void startProgress() {
    timer?.cancel();
    progressValue.value = 0;

    timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      progressValue.value += 0.01;

      if (progressValue.value >= 1) nextImage();
    });
  }

  void nextImage() {
    final images = getCurrentImages();

    if (images.isEmpty) return nextStory();

    if (currentImageIndex.value < images.length - 1) {
      currentImageIndex.value++;
      _preloadCurrentImage();
    } else {
      nextStory();
    }

    startProgress();
  }

  void previousImage() {
    if (currentImageIndex.value > 0) {
      currentImageIndex.value--;
      _preloadCurrentImage();
    } else {
      previousStory();
    }

    startProgress();
  }

  void nextStory() {
    if (globalStories.isEmpty) return;

    currentIndex.value = (currentIndex.value + 1) % globalStories.length;

    currentImageIndex.value = 0;

    _preloadCurrent();
    _preloadNext();
    startProgress();
  }

  void previousStory() {
    if (globalStories.isEmpty) return;

    currentIndex.value =
        (currentIndex.value - 1 + globalStories.length) % globalStories.length;

    currentImageIndex.value = 0;

    _preloadCurrent();
    _preloadNext();
    startProgress();
  }

  void handleGesture(double dx) {
    if (isAnimatingOut) return;

    dragDx.value += dx;
    dragDx.value = dragDx.value.clamp(-300, 300);
  }

  void onSwipeEnd() {
    const threshold = 100;

    if (dragDx.value.abs() > threshold) {
      _animateOut(dragDx.value < 0);
    } else {
      _animateBack();
    }
  }

  void _animateBack() {
    isAnimatingOut = true;

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      dragDx.value *= 0.7;

      if (dragDx.value.abs() < 1) {
        dragDx.value = 0;
        isAnimatingOut = false;
        timer.cancel();
      }
    });
  }

  void _animateOut(bool toLeft) {
    isAnimatingOut = true;

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      dragDx.value += toLeft ? -40 : 40;

      if (dragDx.value.abs() > 400) {
        timer.cancel();

        toLeft ? nextStory() : previousStory();

        dragDx.value = 0;
        isAnimatingOut = false;
      }
    });
  }

  void _preloadCurrent() {
    if (globalStories.isEmpty) return;

    _preloadImage(currentIndex.value);
    _preloadCurrentImage();
  }

  void _preloadNext() {
    if (globalStories.length < 2) return;

    final nextIndex = (currentIndex.value + 1) % globalStories.length;

    _preloadImage(nextIndex);
  }

  void _preloadCurrentImage() {
    final images = getCurrentImages();
    final idx = currentImageIndex.value;

    if (idx < 0 || idx >= images.length) return;

    final url = images[idx];
    if (url.isNotEmpty) {
      precacheImage(NetworkImage(url), Get.context!);
    }
  }

  void _preloadImage(int index) {
    if (index < 0 || index >= globalStories.length) return;

    final url = globalStories[index].popImages?.first.imageUrl;

    if (url != null && url.isNotEmpty) {
      precacheImage(NetworkImage(url), Get.context!);
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
