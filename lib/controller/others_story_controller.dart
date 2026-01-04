import 'dart:async';

import 'package:get/get.dart';

class OthersStoryController extends GetxController {
  final userName = "Jessi smith".obs;
  final timeAgo = "36m ago".obs;
  final currentIndex = 0.obs;
  final progress = 0.0.obs;
  Timer? _timer;

  final myStories = <String>[
    "assets/images/olivia.png",
    "assets/images/davesi.png",
    "assets/images/amiliva.png",
  ].obs;

  void startProgress() {
    _timer?.cancel();
    progress.value = 0.0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      final nxt = progress.value + 0.01; // ~5s
      if (nxt >= 1.0) {
        progress.value = 1.0;
        t.cancel();
        nextStory();
      } else {
        progress.value = nxt;
      }
    });
  }

  void stopProgress() => _timer?.cancel();

  void nextStory() {
    if (currentIndex.value < myStories.length - 1) {
      currentIndex.value++;
    } else {
      currentIndex.value = 0;
    }
    startProgress();
  }

  void next() {
    if (currentIndex.value < myStories.length - 1) {
      currentIndex.value++;
    } else {
      currentIndex.value = 0;
    }
  }

  void prevStory() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      startProgress();
    }
  }
}
