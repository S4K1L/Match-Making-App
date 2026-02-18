import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/auth_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_extension/views/base/system_chrom.dart';
import 'package:flutter_extension/views/screen/Auth/forget_otp_verify_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  @override
  void initState() {
    systemChrom();
    super.initState();
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                    const SizedBox(height: 155),
                    Center(child: Image.asset(Images.appLogo)),
                    const SizedBox(height: 40),
                    Text(
                      "Enter your email".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1A1A1A),
                        fontFamily: "cinzel",
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _emailController,
                      filColor: const Color(0xFFFFFFFF),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        child: SvgPicture.asset('assets/icons/email.svg'),
                      ),
                      filled: true,
                    ),

                    const SizedBox(height: 32),
                    Obx(() {
                      return CustomButton(
                        loading: _authController.isLoading.value,
                        onTap: () async {
                          final response = await _authController.forgotPassword(
                            _emailController.text,
                          );
                          if (response == "success") {
                            Get.to(
                              () => ForgetOtpVerifyScreen(
                                email: _emailController.text,
                              ),
                            );
                          } else {
                            showCustomSnackBar(response, isError: true);
                          }
                        },
                        text: "Send Otp".toUpperCase(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
