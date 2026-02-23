import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_extension/model/view_model.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_extension/util/image_utils.dart';
import 'package:flutter_extension/views/screen/home/AllSubScreen/add_story_screen.dart';
import 'package:get/get.dart';

import '../model/my_story_model.dart';

class MyStoryController extends GetxController {
  final ApiService _apiService = ApiService();

  final Rx<File?> pickedStory = Rx<File?>(null);

  final RxList<MyStoryModel> myStories = <MyStoryModel>[].obs;

  final currentIndex = 0.obs;
  final progress = 0.0.obs;
  final isLoading = false.obs;

  final showViewers = false.obs;

  final viewers = <Viewer>[
    Viewer(
      name: "Tacos al Pastor",
      avatar: "assets/images/amiliva.png",
      distance: "1.0 km",
    ),
    Viewer(
      name: "Pierogi",
      avatar: "assets/images/davesi.png",
      distance: "1.0 km",
    ),
    Viewer(
      name: "Moussaka",
      avatar: "assets/images/olivia.png",
      distance: "1.0 km",
    ),
  ].obs;

  int get viewersCount => viewers.length;

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

  Future<void> getStories() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        ApiConstant.mutualSystemMyStory,
        authReq: true,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic data = body['data'];

        final List results = data is List
            ? data
            : (data is Map && data['stories'] is List)
            ? data['stories']
            : <dynamic>[];

        final stories = results
            .map((e) => MyStoryModel.fromJson(e as Map<String, dynamic>))
            .where(_isValidStory)
            .toList();

        myStories.assignAll(stories);

        _resetAndStart();
      }
    } catch (e) {
      debugPrint("Error fetching stories: $e");
    } finally {
      isLoading.value = false;
    }
  }

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
