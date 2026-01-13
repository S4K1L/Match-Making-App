import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_extension/views/screen/Auth/email_verify_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isChecked = false;

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
                  " password".toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Cinzel',
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 10),
                const CustomTextField(
                  isPassword: true,
                  filColor: Color(0xFFFFFFFF),

                  filled: true,
                ),

                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isChecked,
                      activeColor: const Color(0xFF18433B),
                      checkColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFF888888),
                        width: 2,
                      ),
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),

                    Expanded(
           
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: "I AGREE TO THE ",
                          style: const TextStyle(
                            fontFamily: 'Cinzel',
                            fontSize: 12,
                            color: Color(0xFF3C3C3C),
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: "TERMS AND CONDITIONS",
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Cinzel',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0C312B),
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF0C312B),
                                decorationThickness: 1.5,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // open terms
                                },
                            ),
                            const TextSpan(
                              text: " AND ",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Cinzel',
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF3C3C3C),
                              ),
                            ),
                            TextSpan(
                              text: "PRIVACY POLICY",
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Cinzel',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0C312B),
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF0C312B),
                                decorationThickness: 1.5,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // open privacy policy
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 42),
                CustomButton(
                  onTap: () {
                    Get.to(() => const EmailVerifyScreen());
                  },
                  text: "Sign up".toUpperCase(),
                ),
                const SizedBox(height: 20),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have account?".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Cinzel',
                        color: Color(0xFF707270),
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: "  Login".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Cinzel',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0C312B),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.offNamed(AppRoutes.loingScreen);
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
