import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/auth_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/SetupProfile/enable_location_screen.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

class EmailVerifyScreen extends StatefulWidget {
  final String email;
  const EmailVerifyScreen({super.key, required this.email});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  final AuthController _authController = Get.find<AuthController>();
  String _otp = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFF2A2D2A),
                          ),
                        ),
                        const Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF2A2D2A),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 98),

                  Center(child: Image.asset(Images.appLogo)),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      "Email verification".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontFamily: "Cinzel",
                        color: Color(0xFF141615),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Enter your OTP code".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF707270),
                    ),
                  ),
                  const SizedBox(height: 34),

                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: const Color(0xFFEAEAEA),
                    focusedBorderColor: const Color(0xFFEAEAEA),
                    enabledBorderColor: const Color(0xFFEAEAEA),
                    showFieldAsBox: true,
                    fieldWidth: 45,
                    fieldHeight: 45,
                    filled: true,
                    borderRadius: BorderRadius.circular(12),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF707270),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Cinzel",
                    ),
                    fillColor: const Color(0xFFFFFFFF),
                    onCodeChanged: (String code) {
                      _otp = code;
                    },
                    onSubmit: (String verificationCode) async {
                      _otp = verificationCode;
                      final response = await _authController
                          .verifyRegistrationOtp(_otp);
                      if (response == "success") {
                        Get.to(() => const EnableLocationScreen());
                      } else {
                        showCustomSnackBar(response, isError: true);
                      }
                    },
                  ),
                  const SizedBox(height: 34),
                  Obx(
                    () => RichText(
                      text: TextSpan(
                        text: "Didn’t receive code?".toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 14,
                          color: Color(0xFF707270),
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: " Resend again".toUpperCase(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Cinzel',
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF0C312B),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _authController.isLoading.value
                                  ? null
                                  : () async {
                                      final response = await _authController
                                          .resendOtp(widget.email);
                                      if (response == "success") {
                                        showCustomSnackBar(
                                          "OTP sent successfully",
                                        );
                                      } else {
                                        showCustomSnackBar(
                                          response,
                                          isError: true,
                                        );
                                      }
                                    },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(
                      () => CustomButton(
                        loading: _authController.isLoading.value,
                        onTap: () async {
                          final response = await _authController
                              .verifyRegistrationOtp(_otp);
                          if (response == "success") {
                            Get.to(() => const EnableLocationScreen());
                          } else {
                            showCustomSnackBar(response, isError: true);
                          }
                        },
                        text: "Verification Code".toUpperCase(),
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
