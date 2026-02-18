import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/setpu_profile_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/SetupProfile/question9_screen.dart';
import 'package:get/get.dart';

class Question8Screen extends StatefulWidget {
  const Question8Screen({super.key});

  @override
  State<Question8Screen> createState() => _Question8ScreenState();
}

class _Question8ScreenState extends State<Question8Screen> {
  final controller = Get.put(SetpuProfileController());

  final List<String> options = [
    "LAW",
    "INTERIOR DESIGN",
    "FINANCE",
    "AVIATION",
    "CUSTOMER SERVICE",
    "HOMEMAKER",
    "HEALTHCARE",
    "CONSULTING",
    "MARKETING",
    "ENVIRONMENTAL",
    "BEAUTY",
    "SECURITY",
    "EDUCATION",
    "DENTISTRY",
    "SPORTS",
    "TRANSPORTATION",
    "HOSPITALITY",
    "SOCIAL WORK",
    "TRADES",
    "OTHER",
    "ENTREPRENEUR",
    "BUSINESS",
    "REAL ESTATE",
  ];

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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  customAppBar(),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              "about you",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Center(
                            child: Text(
                              "choose your professional field.",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 12,
                            runSpacing: 16,
                            children: options
                                .map((item) => SelectablePill(title: item))
                                .toList(),
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            onTap: () {
                              Get.to(() => const Question9Screen());
                            },
                            text: "Next",
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
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

class SelectablePill extends StatefulWidget {
  final String title;

  const SelectablePill({super.key, required this.title});

  @override
  State<SelectablePill> createState() => _SelectablePillState();
}

class _SelectablePillState extends State<SelectablePill> {
  final controller = Get.put(SetpuProfileController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.isSelected(widget.title);

      return GestureDetector(
        onTap: () => controller.toggleSelectedItem(widget.title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF18433B) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF2A2D2A), width: 1),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : const Color(0xFF2A2D2A),
            ),
          ),
        ),
      );
    });
  }
}
