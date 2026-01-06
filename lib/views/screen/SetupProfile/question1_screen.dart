import 'package:flutter/material.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_extension/views/screen/SetupProfile/question2_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class Question1Screen extends StatefulWidget {
  const Question1Screen({super.key});

  @override
  State<Question1Screen> createState() => _Question1ScreenState();
}

class _Question1ScreenState extends State<Question1Screen> {
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
                customAppBar(),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi! Let’s begin\nwith a quick \nintro."
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 48),
                        const Text(
                          "Full Name",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          hintText: "Enter Your Name".toUpperCase(),
                          filColor: Colors.white,
                          filled: true,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 18,
                            ),
                            child: SvgPicture.asset('assets/icons/user.svg'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Date Of Birth",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          hintText: "DD/MM/YY".toUpperCase(),
                          filColor: Colors.white,
                          filled: true,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 18,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/calender.svg',
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Height",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                hintText: "Feet",
                                filColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            SizedBox(width: 8,),
                            Expanded(
                              child: CustomTextField(
                                hintText: "Inches",
                                filColor: Colors.white,
                                filled: true,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 150),

                        CustomButton(
                          onTap: () {
                            Get.to(() => const Question2Screen());
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
