import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_extension/services/api_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:get/get.dart';

import '../model/others_story_model.dart';

class OthersStoryController extends GetxController {
  final ApiService _apiService = ApiService();

  final currentIndex = 0.obs;
  final progress = 0.0.obs;
  final isLoading = false.obs;

  final RxList<OthersStoryModel> stories = <OthersStoryModel>[].obs;

  Timer? _timer;

  OthersStoryModel? get currentStory =>
      stories.isEmpty ? null : stories[currentIndex.value];

  Future<void> getStories(String userId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        "${ApiConstant.mutualSystemStories}/$userId/user/",
        authReq: true,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = body['data'];

        final List rawList = (data is Map && data['stories'] is List)
            ? data['stories']
            : <dynamic>[];

        final parsed = rawList
            .map((e) => OthersStoryModel.fromJson(e as Map<String, dynamic>))
            .where(_isValidStory)
            .toList();

        stories.assignAll(parsed);

        _resetAndStart();
      }
    } catch (e) {
      debugPrint("Error fetching stories: $e");
    } finally {
      isLoading.value = false;
    }
  }

  bool _isValidStory(OthersStoryModel s) {
    final hasContent =
        (s.media != null && s.media!.isNotEmpty) ||
        (s.text != null && s.text!.isNotEmpty);

    final notExpired = DateTime.now().isBefore(s.expiresAt);

    return hasContent && notExpired;
  }

  void _resetAndStart() {
    currentIndex.value = 0;
    progress.value = 0.0;

    if (stories.isNotEmpty) {
      startProgress();
    }
  }

  void startProgress() {
    if (stories.isEmpty) return;

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
    if (stories.isEmpty) return;

    _timer?.cancel();

    currentIndex.value = (currentIndex.value + 1) % stories.length;

    progress.value = 0.0;

    Future.microtask(() {
      startProgress();
    });
  }

  void prevStory() {
    if (stories.isEmpty) return;

    _timer?.cancel();

    currentIndex.value = (currentIndex.value - 1) < 0
        ? stories.length - 1
        : currentIndex.value - 1;

    progress.value = 0.0;

    startProgress();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
