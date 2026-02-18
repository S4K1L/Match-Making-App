import 'dart:async';
import 'dart:io';

import 'package:flutter_extension/model/view_model.dart';
import 'package:flutter_extension/util/image_utils.dart';
import 'package:flutter_extension/views/screen/home/AllSubScreen/add_story_screen.dart';
import 'package:get/get.dart';

class MyStoryController extends GetxController {
  final userName = "Jessi smith".obs;
  final timeAgo = "36m ago".obs;

  Rx<File?> pickStory = Rx<File?>(null);

  final myStories = <String>[
    "assets/images/olivia.png",
    "assets/images/davesi.png",
    "assets/images/amiliva.png",
  ].obs;

  final currentIndex = 0.obs;
  final progress = 0.0.obs;

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

  // Timer
  Timer? _timer;
  // Progress control
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

  Future<void> pickAddStoryImage({bool fromCamera = false}) async {
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );

    if (pickedFile != null) {
      Get.to(() => AddStoryScreen(imagePath: pickedFile.path));
    } else {
      //Get.back();
    }
  }

  // ONE SCREEN panel toggle
  final showViewers = false.obs;
  void openViewers() {
    showViewers.value = true;
    stopProgress();
  }

  void closeViewers() {
    showViewers.value = false;
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

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
