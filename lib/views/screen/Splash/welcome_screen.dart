import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/auth_controller.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/system_chrom.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    systemChrom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.blackBackground, fit: BoxFit.cover),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(Images.appLogo),
                const SizedBox(height: 10),
                Image.asset("assets/images/welcome.png"),
                const SizedBox(height: 20),
                const Text(
                  "Serious about Love? So are we.",
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Cinzel",
                  ),
                ),
                const SizedBox(height: 84),
                _customButton(
                  text: "Login with Phone Or email",
                  icon: "assets/icons/phone.svg",
                  onTap: () {
                    Get.offAllNamed(AppRoutes.loingScreen);
                  },
                ),
                const SizedBox(height: 16),
                _customButton(
                  text: "Login with Google",
                  icon: "assets/icons/google.svg",
                  onTap: () {
                    Get.find<AuthController>().googleLogin();
                  },
                ),
                const SizedBox(height: 32),

                RichText(
                  text: TextSpan(
                    text: "Don’t have an account?".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFF6C53E),
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: " Sign up".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFF6C53E),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.offNamed(AppRoutes.signupScreen);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customButton({
    required String text,
    required String icon,
    required Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 52,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFDE9C13), Color(0xFFF6C53E)],
            ),
            borderRadius: BorderRadius.circular(180),
            border: Border.all(color: Colors.transparent, width: 0.5),
          ),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(180),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF082E22), Color(0xFF001C13)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  SvgPicture.asset(icon),
                  const SizedBox(width: 8),
                  Text(
                    text.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFF6C53E),
                      fontFamily: "Cinzel",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
