import 'package:flutter_extension/controller/auth_controller.dart';
import 'package:flutter_extension/controller/chat_controller.dart';
import 'package:flutter_extension/controller/home_controller.dart';
import 'package:flutter_extension/controller/rev_cat_controller.dart';
import 'package:flutter_extension/controller/splash_controller.dart';
import 'package:flutter_extension/controller/user_controller.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Permanent controllers (stay in memory)
    Get.put(SplashController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(UserController(), permanent: true);
    Get.put(ChatController(), permanent: true);
    Get.put(RevCatController(), permanent: true);
  }
}
