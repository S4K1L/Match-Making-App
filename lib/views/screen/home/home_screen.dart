import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/home_controller.dart';
import 'package:flutter_extension/controller/user_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/global_story_card.dart';
import 'package:flutter_extension/views/base/story_list_view.dart';
import 'package:flutter_extension/views/screen/Notification/notification_screen.dart';
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
  void initState() {
    super.initState();
    _homeController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _customAppbar(),
                    const SizedBox(height: 22),
                    StoryListView(controller: _homeController),
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
                    GlobalStoryCardView(controller: _homeController),
                  ],
                ),
              ),
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
