import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_extension/helper/dependency_injection.dart';

import 'package:flutter_extension/theme/light_theme.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:get/get.dart';
import 'helper/route_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  InitialBindings().dependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.APP_NAME,
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key,
      theme: light(),
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
      getPages: AppRoutes.page,
      initialRoute: AppRoutes.splashScreen,
    );
  }
}
