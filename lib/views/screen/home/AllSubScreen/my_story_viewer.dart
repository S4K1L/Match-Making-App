import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/my_story_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MyStoryViewer extends StatefulWidget {
  final String thumb;

  const MyStoryViewer({super.key, required this.thumb});

  @override
  State<MyStoryViewer> createState() => _MyStoryViewerState();
}

class _MyStoryViewerState extends State<MyStoryViewer> {
  final _myStoryController = Get.put(MyStoryController());

  @override
  void initState() {
    super.initState();
    _myStoryController.startProgress();
  }

  @override
  void dispose() {
    _myStoryController.stopProgress();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double ph = MediaQuery.of(context).size.height * 0.88;

    /// visible when closed
    final double inset = MediaQuery.of(
      context,
    ).padding.bottom; // safe area bottom
    final double closedBottom = -ph - inset;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),

          Obx(() {
            final path = _myStoryController
                .myStories[_myStoryController.currentIndex.value];
            final isAsset = path.startsWith("assets/");

            return Stack(
              children: [
                // -------- CONTENT (white background) --------
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // ===== ROUNDED STORY CARD =====
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 14,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // image
                                Positioned.fill(
                                  child: isAsset
                                      ? Image.asset(path, fit: BoxFit.cover)
                                      : Image.file(
                                          File(path),
                                          fit: BoxFit.cover,
                                        ),
                                ),

                                // gradient overlay
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: const [0.0, 0.22, 0.78, 1.0],
                                        colors: [
                                          Colors.black.withValues(alpha: 0.55),
                                          Colors.transparent,
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.65),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // tap zones (prev/next)
                                Positioned.fill(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: _myStoryController.prevStory,
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: _myStoryController.nextStory,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // top segmented progress
                                const Positioned(
                                  top: 8,
                                  left: 10,
                                  right: 10,
                                  child: _StoryProgressBar(),
                                ),

                                // top bar (avatar + name + time + close)
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  right: 8,
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 16,
                                        backgroundImage: AssetImage(
                                          "assets/images/olivia.png",
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _myStoryController.userName.value,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            _myStoryController.timeAgo.value,
                                            style: const TextStyle(
                                              color: Color(0xFFA7A7A7),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        padding: const EdgeInsets.all(8),
                                        constraints: const BoxConstraints(),
                                        onPressed: () => Get.back(),
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // ===== BOTTOM ROW (avatars left, add story right) =====
                        Row(
                          children: [
                            // clickable avatars (bigger hit box + ripple)
                            InkWell(
                              onTap: _myStoryController.openViewers,
                              borderRadius: BorderRadius.circular(16),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 6,
                                ),
                                child: _OverlappingViewers(
                                  avatars: [
                                    "assets/images/olivia.png",
                                    "assets/images/davesi.png",
                                    "assets/images/amiliva.png",
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),

                            InkWell(
                              onTap: () {
                                _myStoryController.pickAddStoryImage(
                                  fromCamera: false,
                                );
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset('assets/icons/story.svg'),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Add story",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF707270),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                // ===== SCRIM (tap to close) =====
                Obx(
                  () => _myStoryController.showViewers.value
                      ? Positioned.fill(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _myStoryController.closeViewers,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 180),
                              opacity: 0.22,
                              child: Container(color: Colors.black),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // ===== VIEWERS PANEL (AnimatedPositioned + SafeArea inside) =====
                Obx(
                  () => AnimatedPositioned(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    left: 0,
                    right: 0,
                    bottom: _myStoryController.showViewers.value
                        ? 0
                        : closedBottom,
                    height: ph,
                    child: IgnorePointer(
                      ignoring: !_myStoryController.showViewers.value,
                      child: SafeArea(
                        top: false,
                        left: false,
                        right: false,
                        bottom: true,
                        child: _ViewersPanel(
                          close: _myStoryController.closeViewers,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// -------- Segmented progress bar --------
class _StoryProgressBar extends StatelessWidget {
  const _StoryProgressBar();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MyStoryController>();
    const barH = 4.0, gap = 6.0;

    return Obx(
      () => Row(
        children: List.generate(c.myStories.length, (i) {
          final isCurrent = i == c.currentIndex.value;
          final isPast = i < c.currentIndex.value;

          return Expanded(
            child: Container(
              height: barH,
              margin: const EdgeInsets.symmetric(horizontal: gap / 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.35), // track
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  if (isPast)
                    Positioned.fill(child: Container(color: Colors.white)),
                  if (isCurrent)
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: c.progress.value.clamp(0.0, 1.0),
                      child: Container(color: const Color(0xFF2EAED2)),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// -------- Viewers Panel --------
class _ViewersPanel extends StatelessWidget {
  final VoidCallback close;
  const _ViewersPanel({required this.close});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MyStoryController>();

    return GestureDetector(
      onVerticalDragUpdate: (d) {
        if (d.delta.dy > 8) close();
      },
      child: Material(
        elevation: 12,
        color: Colors.transparent,

        child: Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
            ),

            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // header with Done
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF18433B),
                            foregroundColor: const Color(0xFF0C312B),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: close,
                          child: const Text(
                            "Done",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // thumbnails + add story card
                  SizedBox(
                    height: 104,
                    child: Obx(
                      () => ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: c.myStories.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          if (index < c.myStories.length) {
                            final p = c.myStories[index];
                            final isAsset = p.startsWith("assets/");
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                width: 92,
                                height: 104,
                                color: const Color(0xFFEFF1F4),
                                child: isAsset
                                    ? Image.asset(p, fit: BoxFit.cover)
                                    : Image.file(File(p), fit: BoxFit.cover),
                              ),
                            );
                          } else {
                            return _AddStoryCard(onTap: () {});
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Obx(
                      () => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Viewers(${c.viewersCount})",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // list
                  Expanded(
                    child: Obx(
                      () => ListView.separated(
                        padding: const EdgeInsets.only(top: 4, bottom: 18),
                        itemCount: c.viewers.length,
                        separatorBuilder: (_, __) => const SizedBox(),
                        itemBuilder: (context, i) {
                          final v = c.viewers[i];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(v.avatar),
                            ),
                            title: Text(
                              v.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF1A1A1A),
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Color(0xFF707270),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  v.distance,
                                  style: const TextStyle(
                                    color: Color(0xFF707270),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {},
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------- Helpers --------
class _OverlappingViewers extends StatelessWidget {
  final List<String> avatars;
  const _OverlappingViewers({required this.avatars});

  @override
  Widget build(BuildContext context) {
    const double size = 28, overlap = 12;
    return SizedBox(
      height: size,
      width: size + (avatars.length - 1) * overlap + 8,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < avatars.length; i++)
            Positioned(
              left: i * overlap,
              child: CircleAvatar(
                radius: size / 2,
                backgroundColor: Colors.white, // thin ring
                child: CircleAvatar(
                  radius: (size / 2) - 2,
                  backgroundImage: AssetImage(avatars[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddStoryCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddStoryCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 92,
        height: 104,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/story.svg'),
            const SizedBox(height: 6),
            const Text(
              "Add story",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF707270),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
