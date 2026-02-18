import 'dart:async';

import 'package:flutter_extension/model/story_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  var currentIndex = 0.obs;
  var progressValue = 0.0.obs;

  Timer? timer;

  RxDouble dragDx = 0.0.obs;
  Rxn<Story> myStory = Rxn<Story>();
  bool isAnimatingOut = false;

  bool handledThisGesture = false;

  final List<String> stories = [
    "assets/images/olivia.png",
    "assets/images/davesi.png",
    "assets/images/amiliva.png",
  ];

  RxList<Story> others = <Story>[
    Story(userName: "Olivia", mediaPaths: ["assets/images/olivia.png"]),
    Story(userName: "Dayssi", mediaPaths: ["assets/images/davesi.png"]),
    Story(userName: "Amiliva", mediaPaths: ["assets/images/amiliva.png"]),
    Story(userName: "Sophia", mediaPaths: ["assets/images/sophia.jpg"]),
  ].obs;

  RxInt currentMediaIndex = 0.obs;
  RxInt currentUserIndex = 0.obs;

  /// pick image with gallery
  Future<void> pickAndCreateMyStory() async {
    final files = await _picker.pickMultiImage(imageQuality: 85);
    if (files.isEmpty) return;

    myStory.value = Story(
      userName: "You",
      mediaPaths: files.map((e) => e.path).toList(),
      isMe: true,
    );

    currentMediaIndex.value = 0;

    if (others.isNotEmpty) {
      currentUserIndex.value = 0;
      currentMediaIndex.value = 0;
    }
  }

  @override
  void onInit() {
    super.onInit();
    dragDx.value = 0;
    handledThisGesture = false;
    startProgress();
  }

  /// start progress with body image story
  void startProgress() {
    timer?.cancel();
    progressValue.value = 0;

    timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      progressValue.value += 0.02;
      if (progressValue.value >= 1) {
        t.cancel();
        nextStory();
      }
    });
  }

  void nextStory() {
    currentIndex.value = (currentIndex.value + 1) % stories.length;
    startProgress();
  }

  void previousStory() {
    currentIndex.value =
        (currentIndex.value - 1 + stories.length) % stories.length;
    startProgress();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  /// DRAG
  void handleGesture(double dx) {
    if (isAnimatingOut) return;
    dragDx.value += dx;
    update();
  }

  /// SWIPE END
  void onSwipeEnd() {
    const threshold = 120;

    if (dragDx.abs() > threshold) {
      _animateOut(dragDx < 0);
    } else {
      // snap back
      dragDx.value = 0;
      update();
    }
  }

  /// CARD OUT ANIMATION
  void _animateOut(bool toLeft) {
    isAnimatingOut = true;

    dragDx.value = toLeft ? -700 : 700;
    update();

    Future.delayed(const Duration(milliseconds: 250), () {
      if (toLeft) {
        nextStory();
      } else {
        previousStory();
      }

      // reset
      dragDx.value = 0;
      isAnimatingOut = false;
      update();
    });
  }
}
