import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user_controller.dart';
import 'package:flutter_extension/services/zego_call_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_extension/views/screen/Auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/api_service.dart';
import '../services/shared_prefs_service.dart';

class AuthController extends GetxController {
  RxBool isLoggedIn = false.obs;
  RxBool isLoading = false.obs;
  final api = ApiService();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<String> googleLogin() async {
    isLoading(true);

    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        return "Google sign-in cancelled";
      }

      final GoogleSignInAuthentication auth = await account.authentication;

      if (auth.idToken == null) {
        return "Failed to get Google ID token";
      }

      final payload = {
        "email": account.email,
        "full_name": account.displayName ?? "",
        "google_id": account.id,
        "picture": account.photoUrl ?? "",
        "id_token": auth.idToken,
      };

      final response = await api.post("api/v1/accounts/googleLogin/", payload);

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        setToken(body['access']);
        Get.find<UserController>().setInfo(body['data']['user_profile']);
        await ZegoCallService.initForCurrentUser();
        return "success";
      }

      return body['message'] ?? "Authentication failed";
    } catch (e, s) {
      debugPrint("Google login error: $e");
      debugPrintStack(stackTrace: s);
      return "Google login failed";
    } finally {
      isLoading(false);
    }
  }

  Future<String> login(
    String email,
    String password, {
    bool rememberMe = true,
  }) async {
    isLoading(true);
    try {
      final response = await api.post(ApiConstant.login, {
        "email": email.trim(),
        "password": password.trim(),
      });

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = body['data']['user'];
        final accessToken = body['data']['tokens']['access'];
        Get.find<UserController>().setInfo(userData);
        await setToken(accessToken);
        await ZegoCallService.initForCurrentUser();
        return "success";
      } else {
        return "Please try again.";
      }
    } catch (e) {
      return "Please try again.";
    } finally {
      isLoading(false);
    }
  }

  Future<String> signup(
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      isLoading(true);
      final response = await api.post(ApiConstant.signUp, {
        "email": email.trim(),
        "password": password.trim(),
        "confirm_password": confirmPassword.trim(),
      });
      var body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.find<UserController>().setInfo({
          "user_id": body['data']['user_id'],
          "email": body['data']['email'],
        });
        // setToken(body['data']['tokens']['access']);
        return "success";
      } else {
        return "Please try again.";
      }
    } catch (e) {
      return "Please try again.";
    } finally {
      isLoading(false);
    }
  }

  Future<String> resendOtp(String email) async {
    isLoading(true);
    try {
      final response = await api.post(ApiConstant.resendOtp, {
        "email": email.trim(),
      });

      if (response.statusCode == 200) {
        return "success";
      } else {
        return jsonDecode(response.body)['message'] ?? "Connection Error";
      }
    } catch (e) {
      return "Unexpected error: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }

  Future<String> verifyRegistrationOtp(String code) async {
    try {
      isLoading(true);
      final response = await api.post(ApiConstant.verifyOtpRegistration, {
        "otp": code.trim(),
      });
      var body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setToken(body['data']['tokens']['access']);
        await Get.find<UserController>().getInfo();
        await ZegoCallService.initForCurrentUser();
        return "success";
      } else {
        return "Invalid or expired OTP.";
      }
    } catch (e) {
      return "Unexpected error: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }

  Future<String> verifyForgotPasswordOtp(String code) async {
    try {
      isLoading(true);
      final response = await api.post(ApiConstant.verifyForgotPassword, {
        "otp": code.trim(),
      });
      var body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setToken(body['data']['access_token']);
        return "success";
      } else {
        return "Invalid or expired OTP.";
      }
    } catch (e) {
      return "Unexpected error: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }

  Future<String> forgotPassword(String email) async {
    isLoading(true);
    try {
      final response = await api.post(ApiConstant.forgotPassword, {
        "email": email.trim(),
      });
      var body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await SharedPrefsService.clear();
        return "success";
      } else {
        return body['message'] ?? "Connection Error";
      }
    } catch (e) {
      debugPrint("Error: $e");
      return "Connection Error";
    } finally {
      isLoading(false);
    }
  }

  Future<String> changePassword(String password, String confirmPassword) async {
    isLoading(true);
    try {
      final response = await api.post(ApiConstant.resetPassword, {
        "new_password": password.trim(),
        "confirm_password": confirmPassword.trim(),
      }, authReq: true);
      var body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return "success";
      } else {
        return body['message'] ?? "Connection Error";
      }
    } catch (e) {
      return "Unexpected error: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }

  Future<bool> previouslyLoggedIn() async {
    String? token = await SharedPrefsService.get('token');
    if (token != null) {
      debugPrint('🔍 Token found. Fetching user info...');
      final message = await Get.find<UserController>().getInfo();
      if (message == "success") {
        debugPrint("🟡 Token: $token");
        await ZegoCallService.initForCurrentUser();
        isLoggedIn.value = true;
        return true;
      }
    }
    isLoggedIn.value = false;
    return false;
  }

  Future<void> logout() async {
    ZegoCallService.uninit();
    await SharedPrefsService.clear();
    Get.offAll(() => LoginScreen());
    isLoggedIn.value = false;
  }

  Future<void> deleteAccount() async {
    await api.delete(ApiConstant.deleteAccount, authReq: true);
    ZegoCallService.uninit();
    await SharedPrefsService.clear();
    Get.offAll(() => LoginScreen());
  }

  Future<void> setToken(String value) async {
    await SharedPrefsService.set('token', value);
    debugPrint('💾 Token Saved: $value');
  }
}
