import 'package:flutter/material.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BottomMenu extends StatelessWidget {
  final int menuIndex;

  const BottomMenu(this.menuIndex, {super.key});

  Color colorByIndex(ThemeData theme, int index) {
    return index == menuIndex
        ? const Color(0xFFD4AF37)
        : const Color(0xFF707270);
  }

  BottomNavigationBarItem getItem(
    String image,
    String title,
    ThemeData theme,
    int index,
  ) {
    return BottomNavigationBarItem(
      label: title,
      icon: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SvgPicture.asset(
          image,
          height: 24.0,
          width: 24.0,
          color: colorByIndex(theme, index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<BottomNavigationBarItem> menuItems = [
      getItem("assets/icons/home.svg", 'Home', theme, 0),
      getItem("assets/icons/star.svg", 'Matches', theme, 1),
      getItem("assets/icons/chat.svg", 'Chats', theme, 2),
      getItem("assets/icons/profile.svg", 'Profile', theme, 3),
      getItem("assets/icons/menu.svg", 'Menu', theme, 4),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBE1BF),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2EAED2).withValues(alpha: 0.12),
            offset: const Offset(0, -4),
            spreadRadius: 0,
            blurRadius: 9,
          ),
        ],
      ),
      child: ClipRRect(
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFFEBE1BF),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFD4AF37),
          currentIndex: menuIndex,
          selectedLabelStyle: const TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
            color: Color(0xFF707270),
            fontWeight: FontWeight.w400,
          ),
          onTap: (value) {
            switch (value) {
              case 0:
                Get.offAndToNamed(AppRoutes.homeScreen);
                break;
              case 1:
                Get.offAndToNamed(AppRoutes.mathchesScreen);
                break;
              case 2:
                Get.offAndToNamed(AppRoutes.inboxScreen);
                break;
              case 3:
                Get.offAndToNamed(AppRoutes.profileScreen);
                break;
              case 4:
                //showMenuBottomSheet(context);
                Get.offAndToNamed(AppRoutes.menuScreen);

                break;
            }
          },
          items: menuItems,
        ),
      ),
    );
  }

  void showMenuBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.55,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                  child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
                ),
              ),

              /// Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(Images.appLogo, height: 64, width: 80),

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

                 
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }



}
