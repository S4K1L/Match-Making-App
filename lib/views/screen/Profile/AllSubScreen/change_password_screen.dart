import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/auth_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final AuthController _authController = Get.find<AuthController>();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),

          SafeArea(
            child: Column(
              children: [
                _header(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        _title(),
                        const SizedBox(height: 40),
                        _passwordField(),
                        const SizedBox(height: 16),
                        _confirmPasswordField(),
                        const SizedBox(height: 36),
                        _button(),
                        const SizedBox(height: 20),
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

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          InkWell(
            onTap: Get.back,
            child: const Icon(Icons.arrow_back_ios, color: Color(0xFF707270)),
          ),
          const Spacer(),
          Text(
            "Password Changes",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _title() {
    return Column(
      children: [
        Center(
          child: Text(
            "Set New Password",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            "Set your new password",
            style: TextStyle(fontSize: 14, color: Color(0xFF2A2D2A)),
          ),
        ),
      ],
    );
  }

  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter New Password",
          style: TextStyle(fontSize: 16, color: AppColors.textColor),
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: _passwordController,
          hintText: "Enter Password",
          isPassword: true,
          filColor: Colors.white,
          filled: true,
        ),
      ],
    );
  }

  Widget _confirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter Confirm Password",
          style: TextStyle(fontSize: 16, color: AppColors.textColor),
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: _confirmPasswordController,
          hintText: "Enter Confirm Password",
          isPassword: true,
          filColor: Colors.white,
          filled: true,
        ),
      ],
    );
  }

  Widget _button() {
    return Obx(
      () => CustomButton(
        loading: _authController.isLoading.value,
        onTap: _handleSubmit,
        text: "Save",
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      showCustomSnackBar("All fields are required");
      return;
    }

    if (password != confirm) {
      showCustomSnackBar("Passwords do not match");
      return;
    }

    final response = await _authController.changePassword(password, confirm);

    if (response == "success") {
      showCustomSnackBar("Password changed successfully", isError: false);
      _clear();
    }
  }

  void _clear() {
    _passwordController.clear();
    _confirmPasswordController.clear();
  }
}
