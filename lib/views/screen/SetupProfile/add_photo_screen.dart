import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/setpu_profile_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/SetupProfile/face_scanning_screen.dart';
import 'package:get/get.dart';

class AddPhotoScreen extends StatefulWidget {
  const AddPhotoScreen({super.key});

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: customAppBar(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Profile Photos",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Add at least 4 photos whether it’s you smiling with friends, chilling at home, or exploring somewhere new.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2A2D2A),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Obx(() {
                        return GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(12),
                          itemCount: _setupProfileController.images.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 109 / 125,
                              ),
                          itemBuilder: (context, index) {
                            bool hasImage =
                                _setupProfileController.images[index] != null;

                            return GestureDetector(
                              onTap: () {
                                if (!hasImage) {
                                  _setupProfileController.pickImage(index);
                                }
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: 125,
                                    width: 109,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: const Color(0xFFF3F3F3),
                                      border: hasImage
                                          ? Border.all(
                                              color: AppColors.primaryColor,
                                              width: 2,
                                            )
                                          : null,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: hasImage
                                          ? Image.file(
                                              File(
                                                _setupProfileController
                                                    .images[index]!
                                                    .path,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                  ),

                                  if (!hasImage)
                                    const Positioned.fill(
                                      child: DottedBorder(
                                        options: RoundedRectDottedBorderOptions(
                                          strokeWidth: 2,
                                          dashPattern: [4, 4],
                                          color: Color(0xFFA1A1A1),
                                          radius: Radius.circular(12),
                                        ),
                                        child: SizedBox(),
                                      ),
                                    ),

                                  
                                  if (index == 0 && hasImage)
                                    Positioned(
                                      top: 6,
                                      left: 6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Text(
                                          "Main",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 8,
                                            color: Color(0xFF1A1A1A),
                                          ),
                                        ),
                                      ),
                                    ),

                              
                                  Positioned(
                                    bottom: 2,
                                    right: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (hasImage) {
                                          _setupProfileController.removeImage(
                                            index,
                                          );
                                        } else {
                                          _setupProfileController.pickImage(
                                            index,
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: hasImage
                                              ? const Color(0xFFC9A86A)
                                              : const Color(0xFF18433B),
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          hasImage ? Icons.close : Icons.add,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),

                      const SizedBox(height: 140),
                      CustomButton(
                        onTap: () {
                          Get.to(() => const FaceScanningScreen());
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
