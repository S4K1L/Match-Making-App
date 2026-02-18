import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/home_controller.dart';
import 'package:flutter_extension/controller/user_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/story_thumb.dart';
import 'package:flutter_extension/views/screen/Notification/notification_screen.dart';
import 'package:flutter_extension/views/screen/home/AllSubScreen/details_page.dart';
import 'package:flutter_extension/views/screen/home/AllSubScreen/my_story_viewer.dart';
import 'package:flutter_extension/views/screen/home/AllSubScreen/others_story_viewer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeController = Get.put(HomeController());
  final _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _customAppbar(),

                  const SizedBox(height: 22),
                  Obx(() {
                    final total =
                        1 +
                        (_homeController.myStory.value != null ? 1 : 0) +
                        _homeController.others.length;
                    return SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: total,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, idx) {
                          final hasMine = _homeController.myStory.value != null;
                          final isAdd = idx == 0;
                          final isMine = !isAdd && hasMine && idx == 1;

                          String title;
                          String? thumb;
                          if (isAdd) {
                            title = "Add Story";
                          } else if (isMine) {
                            title = "Your Story";
                            thumb =
                                _homeController.myStory.value!.mediaPaths.first;
                          } else {
                            final other = _homeController
                                .others[idx - 1 - (hasMine ? 1 : 0)];
                            title = other.userName;
                            thumb = other.mediaPaths.first;
                          }

                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (isAdd) {
                                    await _homeController
                                        .pickAndCreateMyStory();
                                  } else if (isMine) {
                                    _homeController.currentMediaIndex.value = 0;
                                    await Get.to(
                                      () => MyStoryViewer(thumb: thumb!),
                                    );
                                  } else {
                                    _homeController.currentUserIndex.value =
                                        idx - 1 - (hasMine ? 1 : 0);
                                    _homeController.currentMediaIndex.value = 0;
                                    await Get.to(
                                      () => const OthersStoryViewer(),
                                    );
                                  }
                                },
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFFFFFFF),
                                    border: Border.all(
                                      color: const Color(0xFFF6C53E),

                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: isAdd
                                        ? const Center(
                                            child: Icon(
                                              Icons.add,
                                              size: 30,
                                              color: Color(0xFF0C312B),
                                            ),
                                          )
                                        : StoryThumb(path: thumb!),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF141615),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 18),
                  const Text(
                    "Near You",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF141615),
                    ),
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      _homeController.handleGesture(details.delta.dx);
                    },
                    onHorizontalDragEnd: (_) {
                      _homeController.onSwipeEnd();
                    },
                    child: SizedBox(
                      height: 500,
                      width: double.infinity,
                      child: Obx(() {
                        final dx = _homeController.dragDx.value;

                        // next index for background card
                        final nextIndex =
                            (_homeController.currentIndex.value + 1) %
                            _homeController.stories.length;

                        return Stack(
                          children: [
                            /// 🔹 BACK CARD (NEXT PROFILE)
                            Positioned.fill(
                              child: Transform.scale(
                                scale: 0.95,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        _homeController.stories[nextIndex],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// 🔹 FRONT CARD (CURRENT - SWIPEABLE)
                            Transform.translate(
                              offset: Offset(dx, 0),
                              child: Transform.rotate(
                                origin: const Offset(0, 200),
                                angle: dx * 0.004,
                                child: Stack(
                                  children: [
                                    /// IMAGE
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              _homeController
                                                  .stories[_homeController
                                                  .currentIndex
                                                  .value],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// PROGRESS BAR
                                    Positioned(
                                      top: 20,
                                      left: 10,
                                      right: 10,
                                      child: Row(
                                        children: List.generate(
                                          _homeController.stories.length,
                                          (index) {
                                            return Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                    ),
                                                child: LinearProgressIndicator(
                                                  value:
                                                      index ==
                                                          _homeController
                                                              .currentIndex
                                                              .value
                                                      ? _homeController
                                                            .progressValue
                                                            .value
                                                      : index <
                                                            _homeController
                                                                .currentIndex
                                                                .value
                                                      ? 1
                                                      : 0,
                                                  backgroundColor: Colors.white,
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                        Color
                                                      >(Color(0xFF18433B)),
                                                  minHeight: 4,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),

                                    /// BOTTOM INFO
                                    Positioned(
                                      bottom: 20,
                                      left: 10,
                                      right: 20,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Row(
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                color: Color(0xFF00CD07),
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
                                          InkWell(
                                            onTap: () {
                                              Get.to(() => const DetailsPage());
                                            },
                                            child: const Text(
                                              "Jhon Mandela",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 32,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              buildTag(
                                                "assets/images/w.png",
                                                "Wine",
                                              ),

                                              buildTag(
                                                "assets/images/g.png",
                                                "Gardening",
                                              ),

                                              buildTag(
                                                "assets/images/c.png",
                                                "Coffee",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildTag(String asset, String text) {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Row(
        children: [
          Image.asset(asset, height: 16, width: 16),
          const SizedBox(width: 3),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _customAppbar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to BLINK",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Obx(
                () => Text(
                  _userController.userInfo.value!.fullName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF707270),
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Get.to(() => const NotificationScreen());
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF8FDFF),
                border: Border.all(
                  color: const Color(0xFF2EAED2).withValues(alpha: 0.20),
                  width: 0.3,
                ),
              ),

              child: Center(
                child: SvgPicture.asset('assets/icons/notification.svg'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
