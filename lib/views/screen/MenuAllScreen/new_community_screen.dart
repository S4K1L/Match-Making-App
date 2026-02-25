import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/society_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NewCommunityScreen extends StatefulWidget {
  const NewCommunityScreen({super.key});

  @override
  State<NewCommunityScreen> createState() => _NewCommunityScreenState();
}

class _NewCommunityScreenState extends State<NewCommunityScreen> {
  final SocietyController controller = Get.put(SocietyController());

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF001C13),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        "New Society",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF001C13),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),

                const SizedBox(height: 38),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Obx(() {
                            return InkWell(
                              onTap: controller.pickImage,
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  image: controller.profileImage.value != null
                                      ? DecorationImage(
                                          image: FileImage(
                                            File(
                                              controller
                                                  .profileImage
                                                  .value!
                                                  .path,
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: controller.profileImage.value == null
                                    ? Padding(
                                        padding: const EdgeInsets.all(30),
                                        child: SvgPicture.asset(
                                          'assets/icons/add.svg',
                                        ),
                                      )
                                    : null,
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 8),

                        const Center(
                          child: Text(
                            "Upload Image",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF234F38),
                            ),
                          ),
                        ),

                        const SizedBox(height: 38),

                        const Text(
                          "Name your Society",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF001C13),
                          ),
                        ),

                        const SizedBox(height: 8),

                        CustomTextField(
                          controller: controller.societyNameController,
                          hintText: "Society Name",
                          filColor: Colors.white,
                          filled: true,
                        ),

                        const SizedBox(height: 68),

                        Obx(() {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : CustomButton(
                                    onTap: controller.createSociety,
                                    text: "Create",
                                  ),
                          );
                        }),
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
