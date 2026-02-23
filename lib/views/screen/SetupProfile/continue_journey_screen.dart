import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/SetupProfile/question1_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ContinueJourneyScreen extends StatefulWidget {
  const ContinueJourneyScreen({super.key});

  @override
  State<ContinueJourneyScreen> createState() => _ContinueJourneyScreenState();
}

class _ContinueJourneyScreenState extends State<ContinueJourneyScreen> {
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
                customAppBar(),
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      Center(
                        child: SvgPicture.asset('assets/icons/privacy.svg'),
                      ),
                      const SizedBox(height: 32),
                      const Center(
                        child: Text(
                          "Your Journey to Meaningful Connections starts here",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          "Curated for you, with intention",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF2A2D2A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 270),

                      CustomButton(
                        onTap: () {
                          Get.to(() => const Question1Screen());
                        },
                        text: "Continue",
                      ),
                      const SizedBox(height: 16),

                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Make changes in device settings at any time."
                                .toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'Cinzel',
                              fontSize: 12,
                              color: Color(0xFF3C3C3C),
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: "Learn more in our".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Cinzel',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF3C3C3C),
                                ),

                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),

                              const TextSpan(
                                text: " Privacy Policy",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Cinzel',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0C312B),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFF0C312B),
                                  decorationThickness: 1.5,
                                ),
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
          ),
        ],
      ),
    );
  }
}
