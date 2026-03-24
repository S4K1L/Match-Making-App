import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/auth_controller.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/bottom_menu.dart';
import 'package:flutter_extension/views/base/system_chrom.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    systemChrom();
    Future.delayed(const Duration(seconds: 3), () async {
      final isLoggedIn = await authController.previouslyLoggedIn();
      if (isLoggedIn) {
        Get.offAll(() => CustomBottomNavbar());
      } else {
        Get.offNamed(AppRoutes.welcomeScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.blackBackground, fit: BoxFit.cover),
          ),

          Center(child: Image.asset(Images.appLogo)),
        ],
      ),
    );
  }
}
