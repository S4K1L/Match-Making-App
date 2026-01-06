import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/setpu_profile_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_radio_button.dart';
import 'package:flutter_extension/views/screen/SetupProfile/question_screen7.dart';
import 'package:get/get.dart';

class Question6Screen extends StatefulWidget {
  const Question6Screen({super.key});

  @override
  State<Question6Screen> createState() => _Question6ScreenState();
}

class _Question6ScreenState extends State<Question6Screen> {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customAppBar(),
                  const SizedBox(height: 24),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "WHAT BRINGS YOU TO BLINK?",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Begin your Journey to Love, Friendship or a new kind of connection. Choose what inspires you.",
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
                              "Love",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707270),
                              ),
                            ),
                            const Spacer(),
                            Obx(() {
                              bool isSelect = _setupProfileController
                                  .selectedRelations
                                  .contains("Love");
                              return CustomRadioButton(
                                value: isSelect,
                                onChanged: (val) {
                                  _setupProfileController.toggleSelection(
                                    "Love",
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
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
                              "Friendship",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707270),
                              ),
                            ),
                            const Spacer(),
                            Obx(() {
                              bool isSelect = _setupProfileController
                                  .selectedRelations
                                  .contains("Friendship");
                              return CustomRadioButton(
                                value: isSelect,
                                onChanged: (val) {
                                  _setupProfileController.toggleSelection(
                                    "Friendship",
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
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
                              "Networking",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707270),
                              ),
                            ),
                            const Spacer(),
                            Obx(() {
                              bool isSelect = _setupProfileController
                                  .selectedRelations
                                  .contains("Networking");
                              return CustomRadioButton(
                                value: isSelect,
                                onChanged: (val) {
                                  _setupProfileController.toggleSelection(
                                    "Networking",
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
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
                              "Neurodiverse Connection",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707270),
                              ),
                            ),
                            const Spacer(),
                            Obx(() {
                              bool isSelect = _setupProfileController
                                  .selectedRelations
                                  .contains("Neurodiverse Connection");
                              return CustomRadioButton(
                                value: isSelect,
                                onChanged: (val) {
                                  _setupProfileController.toggleSelection(
                                    "Neurodiverse Connection",
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
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
                              "Adventure Partner",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707270),
                              ),
                            ),
                            const Spacer(),
                            Obx(() {
                              bool isSelect = _setupProfileController
                                  .selectedRelations
                                  .contains("Adventure Partner");
                              return CustomRadioButton(
                                value: isSelect,
                                onChanged: (val) {
                                  _setupProfileController.toggleSelection(
                                    "Adventure Partner",
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 17),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Choose all ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2A2D2A),
                            ),
                          ),

                          Obx(() {
                            bool isAllSelected =
                                _setupProfileController
                                    .selectedRelations
                                    .length ==
                                5;
                            return GestureDetector(
                              onTap: () {
                                if (isAllSelected) {
                                  _setupProfileController.deselectAll();
                                } else {
                                  _setupProfileController.selectAll();
                                }
                              },
                              child: Icon(
                                isAllSelected
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: isAllSelected
                                    ? const Color(0xFF18433B)
                                    : Colors.black,
                              ),
                            );
                          }),
                        ],
                      ),

                      const SizedBox(height: 72),

                      CustomButton(
                        onTap: () {
                          Get.to(() => const QuestionScreen7());
                        },
                        text: "Next",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
