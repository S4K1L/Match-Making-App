import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_extension/model/global_story_model.dart';
import 'package:flutter_extension/model/mutual_story_list_model.dart';
import 'package:flutter_extension/model/story_model.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  RxList<GlobalStoryModel> globalStories = <GlobalStoryModel>[].obs;
  RxList<MutualStoryModel> mutualStories = <MutualStoryModel>[].obs;
  Rxn<Story> myStory = Rxn<Story>();

  RxBool isLoading = false.obs;

  RxInt currentIndex = 0.obs;
  RxInt currentImageIndex = 0.obs;

  RxDouble progressValue = 0.0.obs;
  RxDouble dragDx = 0.0.obs;

  Timer? timer;
  bool isAnimatingOut = false;

  List<dynamic> get allStories {
    final list = <dynamic>[];

    if (myStory.value != null) {
      list.add(myStory.value);
    }

    list.addAll(mutualStories);
    list.addAll(globalStories);

    return list;
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllStories();
  }

  Future<void> fetchAllStories() async {
    isLoading.value = true;

    try {
      await Future.wait([fetchGlobalStories(), fetchMutualStories()]);

      if (allStories.isNotEmpty) {
        currentIndex.value = 0;
        currentImageIndex.value = 0;

        _preloadCurrent();
        _preloadNext();

        startProgress();
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchGlobalStories() async {
    final response = await _apiService.get(
      ApiConstant.globalFeed,
      authReq: true,
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final list = (body['data']['results'] as List)
          .where((e) {
            final popImages = e['pop_images'];
            return popImages is List && popImages.isNotEmpty;
          })
          .map((e) => GlobalStoryModel.fromJson(e))
          .toList();

      globalStories.value = list;
    }
  }

  Future<void> fetchMutualStories() async {
    final response = await _apiService.get(
      ApiConstant.mutualSystemGlobalStory,
      authReq: true,
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final list = (body['data'] as List)
          .map((e) => MutualStoryModel.fromJson(e))
          .toList();

      mutualStories.value = list;
    }
  }

  Future<void> pickImage() async {
    final files = await _picker.pickMultiImage(imageQuality: 85);
    if (files.isEmpty) return;

    createStory();

    currentIndex.value = 0;
    currentImageIndex.value = 0;

    _preloadCurrent();
    _preloadNext();

    startProgress();
  }

  void createStory() async {
    isLoading.value = true;
    try {
      final response = await _apiService.post(
        ApiConstant.mutualSystemCreateStory,
        {"media": myStory.value?.mediaPaths},
        authReq: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;
        fetchMutualStories();
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<String> getCurrentImages() {
    final item = allStories[currentIndex.value];

    if (item is Story) {
      return item.mediaPaths;
    }

    if (item is GlobalStoryModel) {
      return item.popImages?.map((e) => e.imageUrl ?? "").toList() ?? [];
    }

    if (item is MutualStoryModel) {
      if (item.media != null) {
        return ["http://10.10.12.111:8000${item.media}"];
      }
    }

    return [];
  }

  void startProgress() {
    timer?.cancel();
    progressValue.value = 0;

    timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      progressValue.value += 0.01;

      if (progressValue.value >= 1) {
        nextImage();
      }
    });
  }

  void nextImage() {
    final images = getCurrentImages();

    if (images.isEmpty) {
      nextStory();
      return;
    }

    if (currentImageIndex.value < images.length - 1) {
      currentImageIndex.value++;
      _preloadCurrentImage();
    } else {
      nextStory();
    }

    progressValue.value = 0;
    startProgress();
  }

  void previousImage() {
    if (currentImageIndex.value > 0) {
      currentImageIndex.value--;
      _preloadCurrentImage();
    } else {
      previousStory();
    }

    progressValue.value = 0;
    startProgress();
  }

  void nextStory() {
    if (allStories.isEmpty) return;

    currentIndex.value = (currentIndex.value + 1) % allStories.length;
    currentImageIndex.value = 0;

    _preloadCurrent();
    _preloadNext();

    startProgress();
  }

  void previousStory() {
    if (allStories.isEmpty) return;

    currentIndex.value =
        (currentIndex.value - 1 + allStories.length) % allStories.length;

    currentImageIndex.value = 0;

    _preloadCurrent();
    _preloadNext();

    startProgress();
  }

  void onTap(TapUpDetails details, double width) {
    if (details.localPosition.dx < width / 2) {
      previousImage();
    } else {
      nextImage();
    }
  }

  void handleGesture(double dx) {
    if (isAnimatingOut) return;

    dragDx.value += dx;

    if (dragDx.value > 300) dragDx.value = 300;
    if (dragDx.value < -300) dragDx.value = -300;
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

    const duration = 200;
    const frameRate = 16;
    int steps = duration ~/ frameRate;
    double start = dragDx.value;

    int currentStep = 0;

    Timer.periodic(const Duration(milliseconds: frameRate), (timer) {
      currentStep++;

      double t = currentStep / steps;
      double eased = 1 - (1 - t) * (1 - t); // easeOut

      dragDx.value = start * (1 - eased);

      if (currentStep >= steps) {
        dragDx.value = 0;
        isAnimatingOut = false;
        timer.cancel();
      }
    });
  }

  void _animateOut(bool toLeft) {
    isAnimatingOut = true;

    const duration = 250;
    const frameRate = 16;

    int steps = duration ~/ frameRate;
    double start = dragDx.value;
    double end = toLeft ? -400 : 400;

    int currentStep = 0;

    Timer.periodic(const Duration(milliseconds: frameRate), (timer) {
      currentStep++;

      double t = currentStep / steps;
      double eased = Curves.easeOut.transform(t);

      dragDx.value = start + (end - start) * eased;

      if (currentStep >= steps) {
        timer.cancel();

        if (toLeft) {
          nextStory();
        } else {
          previousStory();
        }

        dragDx.value = 0;
        isAnimatingOut = false;
      }
    });
  }

  void _preloadCurrent() {
    if (allStories.isEmpty) return;
    _preloadImage(currentIndex.value);
    _preloadCurrentImage();
  }

  void _preloadNext() {
    if (allStories.length < 2) return;

    final nextIndex = (currentIndex.value + 1) % allStories.length;
    _preloadImage(nextIndex);
  }

  void _preloadCurrentImage() {
    final images = getCurrentImages();
    if (images.isEmpty) return;

    final idx = currentImageIndex.value;
    if (idx < 0 || idx >= images.length) return;

    final item = allStories[currentIndex.value];

    if (item is Story) {
      precacheImage(FileImage(File(images[idx])), Get.context!);
    } else {
      final url = images[idx];
      if (url.isNotEmpty) {
        precacheImage(NetworkImage(url), Get.context!);
      }
    }
  }

  void _preloadImage(int index) {
    final item = allStories[index];

    if (item is Story) {
      if (item.mediaPaths.isNotEmpty) {
        precacheImage(FileImage(File(item.mediaPaths.first)), Get.context!);
      }
    }

    if (item is GlobalStoryModel) {
      final url = item.popImages?.first.imageUrl;
      if (url != null) {
        precacheImage(NetworkImage(url), Get.context!);
      }
    }

    if (item is MutualStoryModel) {
      final url = item.media != null
          ? "http://10.10.12.111:8000${item.media}"
          : null;

      if (url != null) {
        precacheImage(NetworkImage(url), Get.context!);
      }
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
