import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/setpu_profile_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/SetupProfile/question10_screen.dart';
import 'package:get/get.dart';

class Question9Screen extends StatefulWidget {
  const Question9Screen({super.key});

  @override
  State<Question9Screen> createState() => _Question9ScreenState();
}

class _Question9ScreenState extends State<Question9Screen> {
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
                        const Text(
                          "TELL US WHAT YOU’RE INTO...",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Select your interests to help us find the right match for you.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF2A2D2A),
                          ),
                        ),
                  
                        const SizedBox(height: 24),
                  
                        Wrap(
                          spacing: 10,
                          runSpacing: 12,
                          children: _setupProfileController.hobbies
                              .map(
                                (hobby) => SelectablePill(
                                  title: hobby["name"],
                                  icon: hobby["icon"],
                                ),
                              )
                              .toList(),
                        ),
                  
                  
                        const SizedBox(height: 30),
                  
                        CustomButton(
                          onTap: () {
                            Get.to(() => const Question10Screen());
                          },
                          text: "Next",
                        ),
                        SizedBox(height: 20,)
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

class SelectablePill extends StatelessWidget {
  final String icon;
  final String title;

  const SelectablePill({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SetpuProfileController());

    return Obx(() {
      final selected = controller.isSelectedField(title);

      return GestureDetector(
        onTap: () => controller.toggleHobby(title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF18433B) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: selected
                  ? const Color(0xFF18433B)
                  : const Color(0xFF2A2D2A),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(icon, height: 11),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF2A2D2A),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
