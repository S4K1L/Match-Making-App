import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/home_controller.dart';
import 'package:flutter_extension/model/global_story_model.dart';
import 'package:flutter_extension/model/mutual_story_list_model.dart';
import 'package:flutter_extension/model/story_model.dart';
import 'package:flutter_extension/views/screen/home/AllSubScreen/my_story_viewer.dart';
import 'package:flutter_extension/views/screen/home/AllSubScreen/others_story_viewer.dart';
import 'package:get/get.dart';

class StoryListView extends StatelessWidget {
  final HomeController controller;

  const StoryListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stories = _buildStoryList(controller);

      return SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: stories.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildAddStoryItem(controller);
            }

            final item = stories[index - 1];
            final data = _mapToUI(item);

            return _StoryItem(
              title: data.title,
              borderColor: data.borderColor,
              child: data.widget,
              onTap: () => _handleTap(controller, item, data.type),
            );
          },
        ),
      );
    });
  }

  List<dynamic> _buildStoryList(HomeController controller) {
    return [
      if (controller.myStory.value != null) controller.myStory.value!,
      ...controller.mutualStories.where(
        (e) => e.user != controller.myStory.value?.userName,
      ),
    ];
  }

  Widget _buildAddStoryItem(HomeController controller) {
    return _StoryItem(
      title: "Add Story",
      borderColor: const Color(0xFFF6C53E),
      child: const Icon(Icons.add, size: 30),
      onTap: controller.pickImage,
    );
  }

  _StoryUIData _mapToUI(dynamic item) {
    if (item is Story) {
      return _StoryUIData(
        title: "Your Story",
        type: StoryType.mine,
        borderColor: const Color(0xFFF6C53E),
        widget: _buildImage(item.mediaPaths.first),
      );
    }

    if (item is MutualStoryModel) {
      final url = item.fullMediaUrl;

      return _StoryUIData(
        title: item.user ?? "User",
        type: StoryType.mutual,
        borderColor: Colors.green,
        widget: _buildImage(url),
      );
    }

    if (item is GlobalStoryModel) {
      final url = item.popImages?.first.imageUrl;

      return _StoryUIData(
        title: item.fullName ?? "User",
        type: StoryType.global,
        borderColor: Colors.blue,
        widget: _buildImage(url),
      );
    }

    return _StoryUIData(
      title: "Unknown",
      type: StoryType.global,
      borderColor: Colors.grey,
      widget: const ColoredBox(color: Colors.grey),
    );
  }

  Widget _buildImage(String? path) {
    if (path == null || path.isEmpty) {
      return const ColoredBox(color: Colors.grey);
    }

    if (path.startsWith("http")) {
      return Image.network(path, fit: BoxFit.cover);
    }

    return Image.file(File(path), fit: BoxFit.cover);
  }

  void _handleTap(
    HomeController controller,
    dynamic item,
    StoryType type,
  ) async {
    switch (type) {
      case StoryType.mine:
        await Get.to(
          () =>
              MyStoryViewer(thumb: controller.myStory.value!.mediaPaths.first),
        );
        break;

      case StoryType.mutual:
      case StoryType.global:
        await Get.to(() => const OthersStoryViewer());
        break;

      case StoryType.add:
        break;
    }
  }
}

/// 🔥 Internal helper (UI only)
class _StoryUIData {
  final String title;
  final StoryType type;
  final Color borderColor;
  final Widget widget;

  _StoryUIData({
    required this.title,
    required this.type,
    required this.borderColor,
    required this.widget,
  });
}

class _StoryItem extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onTap;
  final Color borderColor;

  const _StoryItem({
    required this.title,
    required this.child,
    required this.onTap,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: ClipOval(child: child),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 70,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}

enum StoryType { add, mine, mutual, global }
