import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/setpu_profile_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_radio_button.dart';
import 'package:flutter_extension/views/screen/SetupProfile/question8_screen.dart';
import 'package:get/get.dart';

class Question7Screen extends StatefulWidget {
  const Question7Screen({super.key});

  @override
  State<Question7Screen> createState() => _Question7ScreenState();
}

class _Question7ScreenState extends State<Question7Screen> {
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
                children: [
                  customAppBar(),
                  const SizedBox(height: 24),

                  Column(
                    children: [
                      Center(
                        child: Image.asset(
                          Images.appLogo,
                          height: 64,
                          width: 80,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Center(
                        child: Text(
                          "This OR That",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                OptionRow(label: "Introvert"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Kombucha"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Game of Thrones"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Gucci"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Nightclub"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Intuition"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Burger"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Mountain Cabin"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Sweet"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Dog"),
                              ],
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                OptionRow(label: "Extrovert"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Champagne"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Gilmore Girls"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Nike"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Night at Home"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Logic"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Salad"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Hotel"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Salty"),
                                const SizedBox(height: 24),
                                OptionRow(label: "Cat"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      CustomButton(
                        onTap: () {
                          Get.to(() => const Question8Screen());
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

class OptionRow extends StatelessWidget {
  final String label;

  OptionRow({super.key, required this.label});

  final controller = Get.put(SetpuProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isChecked = controller.isSelected(label);

      return GestureDetector(
        onTap: () => controller.toggle(label),
        child: Row(
          children: [
            CustomRadioButton(
              value: isChecked,
              onChanged: (_) => controller.toggle(label),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      );
    });
  }
}
