import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/connection_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_radio_button.dart';
import 'package:get/get.dart';

class ReportAndIssueScreen extends StatelessWidget {
  final String id;
  ReportAndIssueScreen({super.key, required this.id});

  final ConnectionController _connectionController =
      Get.find<ConnectionController>();

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
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
                    style: TextStyle(fontSize: 16, color: Color(0xFF4F595E)),
                  ),

                  const SizedBox(height: 48),

                  /// 🔥 Dynamic List
                  Obx(
                    () => Column(
                      children: List.generate(
                        _connectionController.reasons.length,
                        (index) {
                          final reason = _connectionController.reasons[index];

                          return Column(
                            children: [
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

                                  Expanded(
                                    child: Text(
                                      reason,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF555755),
                                      ),
                                    ),
                                  ),

                                  CustomRadioButton(
                                    value:
                                        _connectionController
                                            .selectedReasonIndex
                                            .value ==
                                        index,
                                    onChanged: (val) {
                                      _connectionController.reasonSelect(index);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _customDivider(),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 103),
                      child: Obx(
                        () => CustomButton(
                          loading: _connectionController.isLoading.value,
                          onTap: () {
                            _connectionController.reportUser(id);
                          },
                          text: "Submit",
                        ),
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

  Widget _customDivider() {
    return Container(
      width: double.infinity,
      height: 1,
      color: const Color(0xFFE0E0E0),
    );
  }
}
