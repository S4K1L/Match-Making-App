import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_radio_button.dart';
import 'package:get/get.dart';

class ReportAndIssueScreen extends StatefulWidget {
  const ReportAndIssueScreen({super.key});

  @override
  State<ReportAndIssueScreen> createState() => _ReportAndIssueScreenState();
}

class _ReportAndIssueScreenState extends State<ReportAndIssueScreen> {
  final List<bool> _value = [false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),
          const SizedBox(height: 90),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.close, color: Color(0xFF707270)),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "Report An Issue",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "this is anonymous and they aren't notified that they are blocked",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF4F595E),
                    ),
                  ),

                  const SizedBox(height: 48),
                  Row(
                    children: [
                      Container(
                        height: 5,
                        width: 5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF555755),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Harassment or bullying",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF555755),
                        ),
                      ),
                      const Spacer(),
                      CustomRadioButton(
                        value: _value[0],
                        onChanged: (val) {
                          setState(() {
                            _value[0] = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _customDivider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        height: 5,
                        width: 5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF555755),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Offensive content",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF555755),
                        ),
                      ),
                      const Spacer(),
                      CustomRadioButton(
                        value: _value[1],
                        onChanged: (val) {
                          setState(() {
                            _value[1] = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _customDivider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        height: 5,
                        width: 5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF555755),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Technical problem",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF555755),
                        ),
                      ),
                      const Spacer(),
                      CustomRadioButton(
                        value: _value[2],
                        onChanged: (val) {
                          setState(() {
                            _value[2] = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _customDivider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        height: 5,
                        width: 5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF555755),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Other issue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF555755),
                        ),
                      ),
                      const Spacer(),
                      CustomRadioButton(
                        value: _value[3],
                        onChanged: (val) {
                          setState(() {
                            _value[3] = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 103),
                      child: CustomButton(onTap: () {}, text: "Submit"),
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

  Widget _customDivider() {
    return Container(
      width: double.infinity,
      height: 1,
      color: const Color(0xFFE0E0E0),
    );
  }
}
