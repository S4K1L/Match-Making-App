import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/home_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/screen/home/AllSubScreen/details_page.dart';
import 'package:get/get.dart';

class GlobalStoryCardView extends StatelessWidget {
  final HomeController controller;

  const GlobalStoryCardView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTapUp: (details) => Get.to(
        () => DetailsPage(
          globalStoryModel:
              controller.globalStories[controller.currentIndex.value],
        ),
      ),

      onHorizontalDragUpdate: (details) {
        controller.handleGesture(details.delta.dx);
      },

      onHorizontalDragEnd: (_) {
        controller.onSwipeEnd();
      },

      child: SizedBox(
        height: 500,
        width: double.infinity,
        child: Obx(() {
          if (controller.globalStories.isEmpty) {
            return const Center(child: Text("No Stories"));
          }

          final safeIndex = controller.currentIndex.value;

          if (safeIndex >= controller.globalStories.length) {
            return const Center(child: Text("Invalid Index"));
          }

          final story = controller.globalStories[safeIndex];
          final images = controller.getCurrentImages();

          return Stack(
            children: [
              /// BACK CARD
              Positioned.fill(
                child: Transform.scale(
                  scale: 0.95,
                  child: _buildImage(controller, images),
                ),
              ),

              /// FRONT CARD (SWIPE ANIMATION HERE)
              Obx(() {
                final dx = controller.dragDx.value;

                return Transform.translate(
                  offset: Offset(dx, 0),
                  child: Transform.rotate(
                    angle: dx * 0.0015,

                    child: Stack(
                      children: [
                        Positioned.fill(child: _buildImage(controller, images)),

                        Positioned(
                          top: 20,
                          left: 10,
                          right: 10,
                          child: Row(
                            children: List.generate(images.length, (index) {
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  child: LinearProgressIndicator(
                                    value:
                                        index ==
                                            controller.currentImageIndex.value
                                        ? controller.progressValue.value
                                        : index <
                                              controller.currentImageIndex.value
                                        ? 1
                                        : 0,
                                    borderRadius: BorderRadius.circular(12),

                                    backgroundColor: AppColors.primaryColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    minHeight: 5,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        Positioned(
                          bottom: 20,
                          left: 10,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (story.isOnline != null &&
                                  story.isOnline == true)
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Colors.green,
                                      size: 12,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Active",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),

                              const SizedBox(height: 5),
                              Text(
                                story.fullName ?? story.username ?? "",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: (story.hobbies ?? [])
                                    .cast<String>()
                                    .take(3)
                                    .map<Widget>(
                                      (e) => Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          child: buildTag(e),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildImage(HomeController controller, List<String> images) {
    return Obx(() {
      final index = controller.currentImageIndex.value;

      final imageUrl = (images.isNotEmpty && index < images.length)
          ? images[index]
          : null;

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: imageUrl != null
                ? NetworkImage(imageUrl)
                : const AssetImage("assets/images/placeholder.png")
                      as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }

  Widget buildTag(String text) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
