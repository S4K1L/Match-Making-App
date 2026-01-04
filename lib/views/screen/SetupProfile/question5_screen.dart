import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/setpu_profile_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
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
                const SizedBox(height: 56),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "How tall are you?",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),

                        SizedBox(
                          height: 216,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                            
                              Obx(
                                () => CupertinoPicker(
                                  itemExtent: 40,
                                  diameterRatio: 1.2,
                                  squeeze: 1.1,
                                  selectionOverlay: const SizedBox(),

                                  onSelectedItemChanged: (index) {
                                    _setupProfileController
                                            .selectedIndex
                                            .value =
                                        index; 

                                    final value = _setupProfileController
                                        .heightList[index];
                                    final feet = value.floor();
                                    final inch = ((value - feet) * 10).round();

                                    _setupProfileController
                                            .selectedHeight
                                            .value =
                                        "$feet'$inch\""; 
                                  },

                                  children: List.generate(
                                    _setupProfileController.heightList.length,
                                    (index) {
                                      final value = _setupProfileController
                                          .heightList[index];
                                      final feet = value.floor();
                                      final inch = ((value - feet) * 10)
                                          .round();
                                      final text = "$feet'$inch\"";

                                      final isSelected =
                                          _setupProfileController
                                              .selectedIndex
                                              .value ==
                                          index;

                                      return Center(
                                        child: Text(
                                          text,
                                          style: TextStyle(
                                            fontSize: isSelected ? 26 : 22,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? Colors.black
                                                : Colors.grey.shade500,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              IgnorePointer(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10,
                                      sigmaY: 10,
                                    ),
                                    child: Container(
                                      height: 52,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          color: const Color(0xFF1B7F7A),
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Obx(
                                          () => Text(
                                            _setupProfileController
                                                .selectedHeight
                                                .value,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 225),
                        CustomButton(
                          onTap: () {
                            Get.to(() => const Question6Screen());
                          },
                          text: "Next",
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
}
