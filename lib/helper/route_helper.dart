import 'package:flutter_extension/views/screen/Auth/login_screen.dart';
import 'package:flutter_extension/views/screen/Auth/signup_screen.dart';
import 'package:flutter_extension/views/screen/Chat/chat_list.dart';
import 'package:flutter_extension/views/screen/likeYou/like_you_screen.dart';
import 'package:flutter_extension/views/screen/MenuAllScreen/menu_screen.dart';
import 'package:flutter_extension/views/screen/Profile/profile_screen.dart';
import 'package:flutter_extension/views/screen/Splash/welcome_screen.dart';
import 'package:flutter_extension/views/screen/home/home_screen.dart';
import 'package:get/get.dart';

import '../views/screen/splash/splash_screen.dart';

class AppRoutes {
  static String splashScreen = "/splash_screen";
  static String welcomeScreen = "/welcome_screen";
  static String signupScreen = "/signup_screen";
  static String loingScreen = "/loingScreen";
  static String homeScreen = "/home_screen";
  static String mathchesScreen = "/mathches_screen";
  static String inboxScreen = "/inbox_screen";
  static String profileScreen = "/profile_screen";
  static String menuScreen = "/menu_screen";

  static List<GetPage> page = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: welcomeScreen, page: () => const WelcomeScreen()),
    GetPage(name: signupScreen, page: () => const SignupScreen()),
    GetPage(name: loingScreen, page: () => const LoginScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: mathchesScreen, page: () => const MatcheScreen()),
    GetPage(name: inboxScreen, page: () => const ChatListScreen()),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: menuScreen, page: () => const MenuScreen()),
  ];
}
