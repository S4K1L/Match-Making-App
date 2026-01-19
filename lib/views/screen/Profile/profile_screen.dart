import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/bottom_menu..dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_switch.dart';
import 'package:flutter_extension/views/screen/Notification/notification_screen.dart';
import 'package:flutter_extension/views/screen/Profile/AllSubScreen/edit_profile_screen.dart';
import 'package:flutter_extension/views/screen/Profile/AllSubScreen/change_password_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSwitch = false;
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: _customAppbar(),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 92,
                          width: 92,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage("assets/images/amiliva.png"),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: const Color(0xFF707270),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          "Tacos al Pastor",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBE1BF),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: const Color(0xFFDE9C13),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _customListTile(
                              onTap: () {
                                Get.to(() => const EditProfileScreen());
                              },
                              image: "assets/icons/user.svg",
                              title: "Profile Update",
                            ),
                            _customListTile(
                              onTap: () {
                               // Get.to(() => const SubscriptionScreen());
                              },
                              image: "assets/icons/crown.svg",
                              title: "Subscription",
                            ),
                            _customListTile(
                              onTap: () {
                                Get.to(() => const ChangePasswordScreen());
                              },
                              image: "assets/icons/password.svg",
                              title: "Password Change",
                            ),

                            ListTile(
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFF4F1EC),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFE9EAEB,
                                    ).withValues(alpha: 0.20),
                                    width: 0.3,
                                  ),
                                ),

                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/notification_fill.svg",
                                    color: const Color(0xFFF6C53E),
                                  ),
                                ),
                              ),
                              title: const Text(
                                "Notification",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF3B3B3B),
                                ),
                              ),
                              trailing: CustomSwitch(
                                value: isSwitch,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitch = value;
                                  });
                                },
                              ),
                            ),

                            ListTile(
                              onTap: () {
                                showLogoutBottomSheet(context);
                              },
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFF4F1EC),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFE9EAEB,
                                    ).withValues(alpha: 0.20),
                                    width: 0.3,
                                  ),
                                ),

                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/logout.svg",
                                    color: const Color(0xFFF6C53E),
                                  ),
                                ),
                              ),
                              title: const Text(
                                "Log Out",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFD40000),
                                ),
                              ),
                              trailing: const Icon(
                                Icons.navigate_next,
                                color: Color(0xFF3B3B3B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomMenu(3),
    );
  }

  ListTile _customListTile({
    required String image,
    required String title,
    required void Function() onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFF4F1EC),
          border: Border.all(
            color: const Color(0xFFE9EAEB).withValues(alpha: 0.20),
            width: 0.3,
          ),
        ),

        child: Center(
          child: SvgPicture.asset(image, color: const Color(0xFFF6C53E)),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF3B3B3B),
        ),
      ),
      trailing: const Icon(Icons.navigate_next, color: Color(0xFF3B3B3B)),
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
            "Profile",
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

  showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) {
        return Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 35),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Logout",
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.maxFinite,
                    height: 0.5,
                    color: const Color(0xFF222222),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Are you sure you want to log out?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2A2D2A),
                      fontSize: 20,
                    ),
                  ),
             

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF222222),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: CustomButton(onTap: () {}, text: "Logout"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
