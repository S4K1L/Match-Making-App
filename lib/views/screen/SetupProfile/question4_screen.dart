import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/setpu_profile_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_radio_button.dart';
import 'package:flutter_extension/views/screen/SetupProfile/question5_screen.dart';
import 'package:get/get.dart';

class Question4Screen extends StatefulWidget {
  const Question4Screen({super.key});

  @override
  State<Question4Screen> createState() => _Question4ScreenState();
}

class _Question4ScreenState extends State<Question4Screen> {
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
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hey ${_setupProfileController.fullNameController.text}, glad you joined us!",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Pick the gender that best represents you.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2A2D2A),
                        ),
                      ),
                      const SizedBox(height: 48),

                      Container(
                        height: 52,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: const Color(0xFFE8E8E8),
                            width: 1,
                          ),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Female",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707270),
                              ),
                            ),
                            const Spacer(),

                            Obx(() {
                              bool isSelect =
                                  _setupProfileController.selectedMan.value ==
                                  "Female";
                              return CustomRadioButton(
                                value: isSelect,
                                onChanged: (val) {
                                  if (val) {
                                    _setupProfileController.selectedMan.value =
                                        "Female";
                                  } else {
                                    _setupProfileController.selectedMan.value =
                                        "";
                                  }
                                },
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      Container(
                        height: 52,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: const Color(0xFFE8E8E8),
                            width: 1,
                          ),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Male",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707270),
                              ),
                            ),
                            const Spacer(),

                            Obx(() {
                              bool isSelect =
                                  _setupProfileController.selectedMan.value ==
                                  "Male";
                              return CustomRadioButton(
                                value: isSelect,
                                onChanged: (val) {
                                  if (val) {
                                    _setupProfileController.selectedMan.value =
                                        "Male";
                                  } else {
                                    _setupProfileController.selectedMan.value =
                                        "";
                                  }
                                },
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      Container(
                        height: 52,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: const Color(0xFFE8E8E8),
                            width: 1,
                          ),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Other",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707270),
                              ),
                            ),
                            const Spacer(),

                            Obx(() {
                              bool isSelect =
                                  _setupProfileController.selectedMan.value ==
                                  "Other";
                              return CustomRadioButton(
                                value: isSelect,
                                onChanged: (val) {
                                  if (val) {
                                    _setupProfileController.selectedMan.value =
                                        "Other";
                                  } else {
                                    _setupProfileController.selectedMan.value =
                                        "";
                                  }
                                },
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 132),
                      CustomButton(
                        onTap: () {
                          Get.to(() => const Question5Screen());
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
