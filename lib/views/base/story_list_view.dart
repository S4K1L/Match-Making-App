import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/home_controller.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_extension/views/screen/home/AllSubScreen/my_story_viewer.dart';
import 'package:flutter_extension/views/screen/home/AllSubScreen/others_story_viewer.dart';
import 'package:get/get.dart';

enum StoryType { add, mine, mutual }

class _StoryItem {
  final StoryType type;
  final String? title;
  final String? image;
  final dynamic data;

  _StoryItem({required this.type, this.title, this.image, this.data});
}

class StoryListView extends StatelessWidget {
  final HomeController controller;

  const StoryListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = <_StoryItem>[];

      /// ALWAYS ADD BUTTON
      items.add(_StoryItem(type: StoryType.add, title: "Add Story"));

      /// MY STORY
      if (controller.myStory.value != null) {
        items.add(
          _StoryItem(
            type: StoryType.mine,
            title: "Your Story",
            image: controller.myStory.value!.mediaPaths.first,
          ),
        );
      }

      /// MUTUAL STORIES
      for (final story in controller.mutualStories) {
        final img = story.media != null
            ? "${ApiConstant.BASE_URL_IMAGE}${story.media}"
            : null;

        items.add(
          _StoryItem(
            type: StoryType.mutual,
            title: story.user ?? "User",
            image: img,
            data: story,
          ),
        );
      }

      return SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final item = items[index];

            return Column(
              children: [
                GestureDetector(
                  onTap: () => _handleTap(item, controller),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: _borderColor(item.type),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(child: _buildContent(item)),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 70,
                  child: Text(
                    item.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF141615),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  Widget _buildContent(_StoryItem item) {
    if (item.type == StoryType.add) {
      return const Center(
        child: Icon(Icons.add, size: 30, color: Color(0xFF0C312B)),
      );
    }

    if (item.image == null) {
      return const ColoredBox(color: Colors.grey);
    }

    if (item.type == StoryType.mine) {
      return Image.file(File(item.image!), fit: BoxFit.cover);
    }

    return Image.network(
      item.image!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.error)),
    );
  }

  Color _borderColor(StoryType type) {
    switch (type) {
      case StoryType.mine:
        return const Color(0xFFF6C53E);
      case StoryType.mutual:
        return Colors.green;
      case StoryType.add:
        return const Color(0xFFF6C53E);
    }
  }

  /// 🔹 TAP HANDLER
  void _handleTap(_StoryItem item, HomeController controller) async {
    switch (item.type) {
      case StoryType.add:
        await controller.pickImage();
        break;

      case StoryType.mine:
        controller.currentIndex.value = 0;
        await Get.to(() => MyStoryViewer(thumb: item.image!));
        break;

      case StoryType.mutual:
        controller.currentIndex.value = 0;
        await Get.to(() => const OthersStoryViewer());
        break;
    }
  }
}
