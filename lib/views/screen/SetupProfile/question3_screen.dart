import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/setpu_profile_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/SetupProfile/question4_screen.dart';
import 'package:get/get.dart';

class Question3Screen extends StatefulWidget {
  const Question3Screen({super.key});

  @override
  State<Question3Screen> createState() => _Question3ScreenState();
}

class _Question3ScreenState extends State<Question3Screen> {
  final _setupProfileController = Get.put(SetpuProfileController());

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
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          Images.appLogo,
                          height: 64,
                          width: 80,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Customize Your Match Distance.",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "distance to find nearby matches and create real connections.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2A2D2A),
                        ),
                      ),
                      const SizedBox(height: 86),

                   
                      Obx(()=>
                         Slider(
                          value: _setupProfileController.distance.value > 1000
                              ? 1000
                              : _setupProfileController.distance.value,
                          min: 1,
                          max: 1000, 
                          divisions: 1000,
                          label: _setupProfileController.distance.value > 1000
                              ? "Unlimited"
                              : "${_setupProfileController.distance.value.round()} km",
                          onChanged: (val) {
                            if (val == 1000) {
                              _setupProfileController.distance.value =
                                  double.infinity;
                            } else {
                              _setupProfileController.distance.value = val;
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 33),
                      CustomButton(
                        onTap: () {
                          Get.to(() => const Question4Screen());
                        },
                        text: "Next",
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
