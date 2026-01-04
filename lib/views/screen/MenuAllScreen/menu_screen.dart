import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/bottom_menu..dart';
import 'package:flutter_extension/views/screen/MenuAllScreen/culture_life_society.dart';
import 'package:flutter_extension/views/screen/MenuAllScreen/food_wine_screen.dart';
import 'package:flutter_extension/views/screen/MenuAllScreen/neurodiverse_screen.dart';
import 'package:flutter_extension/views/screen/MenuAllScreen/society_group_screen.dart';
import 'package:flutter_extension/views/screen/Notification/notification_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _customAppbar(),
                  const SizedBox(height: 40),

                  Column(
                    children: [
                      Center(
                        child: Image.asset(
                          Images.appLogo,
                          height: 64,
                          width: 80,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "SOCIETY\nGROUP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                      ),

                      const SizedBox(height: 16),

                      _menuItem("ACTIVE & ADVENTURE SOCIETY", () {
                        Get.to(() => const SocietyGroupScreen());
                      }),
                      _menuItem("FOOD & WINE SOCIETY", () {
                        Get.to(() => const FoodWineScreen());
                      }),
                      _menuItem("NEURODIVERSE SOCIETY", () {
                        Get.to(() => const NeurodiverseScreen());
                      }),
                      _menuItem("CULTURE & LIFESTYLE SOCIETY", () {
                        Get.to(() => const CultureLifeSociety());
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomMenu(4),
    );
  }

  Widget _customAppbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(Images.appLogo, width: 52, height: 42),

          Text(
            "Menu",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
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

  Widget _menuItem(String title, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF6C53E)),
          color: const Color(0xFFEBE1BF),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset("assets/icons/group.svg"),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2A2D2A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
