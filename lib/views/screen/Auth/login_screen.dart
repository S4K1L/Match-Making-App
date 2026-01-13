import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_extension/views/base/system_chrom.dart';
import 'package:flutter_extension/views/screen/Auth/forget_password_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 140),
                Center(child: Image.asset(Images.appLogo)),
                const SizedBox(height: 40),
                Text(
                  "Enter your email or Phone".toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Cinzel',
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  filColor: const Color(0xFFFFFFFF),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    child: SvgPicture.asset('assets/icons/email.svg'),
                  ),
                  filled: true,
                ),
                const SizedBox(height: 16),
                Text(
                  "password".toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Cinzel',
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 10),
                const CustomTextField(
                  isPassword: true,
                  filColor: Color(0xFFFFFFFF),

                  filled: true,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const ForgetPasswordScreen());
                    },
                    child: Text(
                      "Forgot password?".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Cinzel',
                        color: Color(0xFF18433B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  onTap: () {
                    Get.offAllNamed(AppRoutes.homeScreen);
                  },
                  text: "Login".toUpperCase(),
                ),
                const SizedBox(height: 20),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don’t have a account?".toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Cinzel',
                        fontSize: 14,
                        color: Color(0xFF707270),
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: "  Sign Up".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Cinzel',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0C312B),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.offNamed(AppRoutes.signupScreen);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
