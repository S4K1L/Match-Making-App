import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/auth_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_extension/views/screen/Auth/login_screen.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Image.asset(Images.appLogo)),
                        const SizedBox(height: 40),
                        Center(
                          child: Text(
                            "Set New password".toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                              fontFamily: "Cinzel",
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          "password".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Cinzel',
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _passwordController,
                          isPassword: true,
                          filColor: Color(0xFFFFFFFF),

                          filled: true,
                        ),

                        const SizedBox(height: 18),
                        Text(
                          "Confirm Password".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Cinzel',
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _confirmPasswordController,
                          isPassword: true,
                          filColor: Color(0xFFFFFFFF),

                          filled: true,
                        ),
                        const SizedBox(height: 36),
                        Obx(
                          () => CustomButton(
                            loading: _authController.isLoading.value,
                            onTap: () async {
                              if (_confirmPasswordController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                showCustomSnackBar(
                                  "Please enter password",
                                  isError: true,
                                );
                                return;
                              }
                              if (_passwordController.text !=
                                  _confirmPasswordController.text) {
                                showCustomSnackBar(
                                  "Password does not match",
                                  isError: true,
                                );
                                return;
                              } else {
                                final response = await _authController
                                    .changePassword(
                                      _passwordController.text,
                                      _confirmPasswordController.text,
                                    );
                                if (response == "success") {
                                  Get.offAll(() => const LoginScreen());
                                } else {
                                  showCustomSnackBar(response, isError: true);
                                  return;
                                }
                              }
                            },
                            text: "Save".toUpperCase(),
                          ),
                        ),
                      ],
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
