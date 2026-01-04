import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/others_story_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OthersStoryViewer extends StatefulWidget {
  const OthersStoryViewer({super.key});

  @override
  State<OthersStoryViewer> createState() => _OthersStoryViewerState();
}

class _OthersStoryViewerState extends State<OthersStoryViewer> {
  final _othersStoryController = Get.put(OthersStoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF2A2D2A),
                        ),
                      ),
                      const Text(
                        "Story",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2A2D2A),
                        ),
                      ),

                      Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/notification.svg',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Obx(() {
                  final path = _othersStoryController
                      .myStories[_othersStoryController.currentIndex.value];
                  final isAsset = path.startsWith("assets/");
                  return Stack(
                    children: [
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.76,
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
                                            ? Image.asset(
                                                path,
                                                fit: BoxFit.cover,
                                              )
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
                                              stops: const [
                                                0.0,
                                                0.22,
                                                0.78,
                                                1.0,
                                              ],
                                              colors: [
                                                Colors.black.withValues(
                                                  alpha: 0.55,
                                                ),
                                                Colors.transparent,
                                                Colors.transparent,
                                                Colors.black.withValues(
                                                  alpha: 0.65,
                                                ),
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
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: _othersStoryController
                                                    .prevStory,
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: _othersStoryController
                                                    .nextStory,
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
                                                  _othersStoryController
                                                      .userName
                                                      .value,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  _othersStoryController
                                                      .timeAgo
                                                      .value,
                                                  style: const TextStyle(
                                                    color: Color(0xFFA7A7A7),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            PopupMenuButton(
                                              color: const Color(0xFFFFFFFF),
                                              onSelected: (value) {},
                                              icon: const Icon(
                                                Icons.more_vert,
                                                color: Colors.white,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context) {
                                                    return [
                                                      PopupMenuItem(
                                                        onTap: () {},
                                                        value: 'account ',
                                                        child: const Text(
                                                          'Block account ',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                              0xFF222222,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      PopupMenuItem(
                                                        onTap: () {},
                                                        value: 'Report profile',
                                                        child: const Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Report profile',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                  0xFF222222,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ];
                                                  },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      height: 78,
                                      width: 78,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,

                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF000000,
                                            ).withValues(alpha: 0.07),
                                            blurRadius: 50,

                                            offset: const Offset(0, 20),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Color(0xFF0C312B),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    height: 78,
                                    width: 78,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF18433B),
                                          Color(0xFF0C312B),
                                        ],
                                      ),
                                      shape: BoxShape.circle,

                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF676767,
                                          ).withValues(alpha: 0.20),
                                          blurRadius: 15,

                                          offset: const Offset(0, 15),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Color(0xFFFFFFFF),
                                      size: 35,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Appbar {}

class _StoryProgressBar extends StatelessWidget {
  const _StoryProgressBar();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OthersStoryController>();
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
                color: Colors.white, // track
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
