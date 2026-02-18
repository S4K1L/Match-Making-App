import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/setpu_profile_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_radio_button.dart';
import 'package:flutter_extension/views/screen/SetupProfile/question6_screen.dart';
import 'package:get/get.dart';

class Question5Screen extends StatefulWidget {
  const Question5Screen({super.key});

  @override
  State<Question5Screen> createState() => _Question5ScreenState();
}

class _Question5ScreenState extends State<Question5Screen> {
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
                      const Text(
                        "Who are you hoping to connect with?",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
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
                              "Women",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707270),
                              ),
                            ),
                            const Spacer(),

                            Obx(() {
                              bool isSelect =
                                  _setupProfileController
                                      .selectedLookingFor
                                      .value ==
                                  "Women";
                              return CustomRadioButton(
                                value: isSelect,
                                onChanged: (val) {
                                  if (val) {
                                    _setupProfileController
                                            .selectedLookingFor
                                            .value =
                                        "Women";
                                  } else {
                                    _setupProfileController
                                            .selectedLookingFor
                                            .value =
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
                              "Men",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707270),
                              ),
                            ),
                            const Spacer(),

                            Obx(() {
                              bool isSelect =
                                  _setupProfileController
                                      .selectedLookingFor
                                      .value ==
                                  "Men";
                              return CustomRadioButton(
                                value: isSelect,
                                onChanged: (val) {
                                  if (val) {
                                    _setupProfileController
                                            .selectedLookingFor
                                            .value =
                                        "Men";
                                  } else {
                                    _setupProfileController
                                            .selectedLookingFor
                                            .value =
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
                              "Non-Binary",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707270),
                              ),
                            ),
                            const Spacer(),

                            Obx(() {
                              bool isSelect =
                                  _setupProfileController
                                      .selectedLookingFor
                                      .value ==
                                  "Non-Binary";
                              return CustomRadioButton(
                                value: isSelect,
                                onChanged: (val) {
                                  if (val) {
                                    _setupProfileController
                                            .selectedLookingFor
                                            .value =
                                        "Non-Binary";
                                  } else {
                                    _setupProfileController
                                            .selectedLookingFor
                                            .value =
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
                              "Choose All",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707270),
                              ),
                            ),
                            const Spacer(),

                            Obx(() {
                              bool isSelect =
                                  _setupProfileController
                                      .selectedLookingFor
                                      .value ==
                                  "Choose All";
                              return CustomRadioButton(
                                value: isSelect,
                                onChanged: (val) {
                                  if (val) {
                                    _setupProfileController
                                            .selectedLookingFor
                                            .value =
                                        "Choose All";
                                  } else {
                                    _setupProfileController
                                            .selectedLookingFor
                                            .value =
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
                          Get.to(() => const Question6Screen());
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
