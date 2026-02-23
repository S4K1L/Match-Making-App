import 'package:flutter/material.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/SetupProfile/privacy_policy_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EnableLocationScreen extends StatefulWidget {
  const EnableLocationScreen({super.key});

  @override
  State<EnableLocationScreen> createState() => _EnableLocationScreenState();
}

class _EnableLocationScreenState extends State<EnableLocationScreen> {
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
                customAppBar(),

                const SizedBox(height: 172),
                Center(child: SvgPicture.asset('assets/icons/location.svg')),
                const SizedBox(height: 32),
                const Center(
                  child: Text(
                    "Enable Location",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Center(
                    child: Text(
                      "You need to enable location to be able to use the BLINK App",

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2A2D2A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 36),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: CustomButton(
                    onTap: () {
                      Get.to(() => const PrivacyPolicyScreen());
                    },
                    text: "Allow Location",
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
