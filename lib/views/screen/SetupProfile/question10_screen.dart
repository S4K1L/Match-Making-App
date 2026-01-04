import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/setpu_profile_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/SetupProfile/question11_screen.dart';
import 'package:get/get.dart';

class Question10Screen extends StatefulWidget {
  const Question10Screen({super.key});

  @override
  State<Question10Screen> createState() => _Question10ScreenState();
}

class _Question10ScreenState extends State<Question10Screen> {
  final List<String> options = [
    "Early Riser",
    "Night Owl",
    "Homebody",
    "Adventurous",
    "Balanced Lifestyle",
    "Outdoorsy",
    "Social",
    "Long-Term Focused",
    "Family-Oriented",
    "Communication-Driven",
    "Loyalty",
    "Emotional Awareness",
    "Trust",
    "Respect",
    "Ambition",
    "Stability",
    "High Energy",
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: customAppBar(),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
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
                            "values & lifestyle",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                  
                        const Center(
                          child: Text(
                            "lifestyle preeerences",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2A2D2A),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                            Get.to(() => const Question11Screen());
                          },
                          text: "Next",
                        ),
                        const SizedBox(height: 24),
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
      final selected = controller.isSelectedLifeStype(widget.title);

      return GestureDetector(
        onTap: () => controller.toggleLife(widget.title),
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
