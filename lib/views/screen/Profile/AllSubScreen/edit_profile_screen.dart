import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/profile_controller.dart';
import 'package:flutter_extension/controller/setpu_profile_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final SetpuProfileController _setupController = Get.put(
    SetpuProfileController(),
  );

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: _customAppbar(),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profileImagePickerUI(_setupController),
                        const SizedBox(height: 22),

                        _headingText(text: "Full Name"),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _setupController.fullNameController,
                          hintText: "Enter your full name",
                          filColor: Colors.white,
                          filled: true,
                        ),
                        const SizedBox(height: 16),
                        _headingText(text: "Bio"),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _setupController.bioController,
                          maxLines: 10,
                          minLines: 1,
                          hintText: "Enter your bio",
                          filColor: Colors.white,
                          filled: true,
                        ),

                        const SizedBox(height: 16),
                        _headingText(text: "Height"),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller:
                                    _setupController.heightFeetController,
                                hintText: "Feet",
                                filColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            SizedBox(width: 13),
                            Expanded(
                              child: CustomTextField(
                                controller:
                                    _setupController.heightInchesController,
                                hintText: "inches",
                                filColor: Colors.white,
                                filled: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _headingText(text: "Hobbies"),
                        // const SizedBox(height: 8),
                        // const CustomTextField(
                        //   hintText: "What are you into?",
                        //   filColor: Colors.white,
                        //   filled: true,
                        // ),

                        // const SizedBox(height: 16),
                        // _headingText(text: "You might like..."),
                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 10,
                          runSpacing: 12,
                          children: _setupController.hobbies
                              .map(
                                (hobby) => SelectablePill(
                                  title: hobby["name"],
                                  icon: hobby["icon"],
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: 50),
                        Obx(
                          () => CustomButton(
                            loading: _setupController.profileUpdating.value,
                            onTap: () {
                              _setupController.editProfile();
                            },
                            text: "Update",
                          ),
                        ),
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

  Widget profileImagePickerUI(SetpuProfileController c) {
    return Obx(() {
      final picked = c.profileImage.value;
      final isUploading = c.profilePhotoUploading.value;

      ImageProvider imageProvider;

      if (picked != null && picked.path.isNotEmpty) {
        imageProvider = FileImage(File(picked.path));
      } else {
        imageProvider = const AssetImage("assets/images/profile.png");
      }

      return Column(
        children: [
          GestureDetector(
            onTap: isUploading ? null : c.profileImagePicker,
            child: Center(
              child: Stack(
                children: [
                  Container(
                    height: 92,
                    width: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: .15),
                          BlendMode.darken,
                        ),
                      ),
                      border: Border.all(
                        color: const Color(0xFF707270),
                        width: 2,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: isUploading
                          ? const SizedBox(
                              height: 26,
                              width: 26,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 22,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          if (picked != null) ...[
            // SizedBox(
            //   width: 160,
            //   height: 42,
            //   child: ElevatedButton(
            //     onPressed: isUploading
            //         ? null
            //         : () async {
            //             final ok = await c.editProfile();
            //             if (!ok) {
            //               Get.snackbar("Error", "Profile image upload failed");
            //             }
            //           },
            //     child: Text(isUploading ? "Uploading..." : "Upload Photo"),
            //   ),
            // ),
            // const SizedBox(height: 8),
            TextButton(
              onPressed: isUploading ? null : c.clearProfileImage,
              child: const Text("Remove"),
            ),
          ],
        ],
      );
    });
  }

  Widget _headingText({required String text}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textColor,
      ),
    );
  }

  Widget _customAppbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios, color: Color(0xFF707270)),
          ),

          Text(
            "Profile Update",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),

          InkWell(
            onTap: () {},
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF8FDFF),
                border: Border.all(
                  color: const Color(0xFF2EAED2).withValues(alpha: 0.20),
                  width: 0.3,
                ),
              ),

              child: Center(
                child: SvgPicture.asset('assets/icons/notification.svg'),
              ),
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
    final controller = Get.put(ProfileController());

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
