import 'package:flutter/widgets.dart';
import 'package:flutter_extension/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoCallConfig {
  // Replace with your ZEGO project credentials.
  static const int appId = 1741106316;
  static const String appSign = '908e90a278829c489c7c1552ad8298f880dd411f1252e3d8e3848f38b7d9dda8';
  static const String callResourceId = 'zegouikit_call';
}

class ZegoCallService {
  static bool _systemCallingUiInitialized = false;
  static bool _invitationServiceInitialized = false;

  static Future<void> setupSystemCallingUI(
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    if (_systemCallingUiInitialized) return;

    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
    await ZegoUIKit().initLog();
    await ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI([
      ZegoUIKitSignalingPlugin(),
    ]);
    _systemCallingUiInitialized = true;
  }

  static Future<void> initForCurrentUser() async {
    if (!_systemCallingUiInitialized) {
      await setupSystemCallingUI(Get.key);
    }

    if (_invitationServiceInitialized) return;
    if (ZegoCallConfig.appId <= 0 || ZegoCallConfig.appSign.isEmpty) return;

    final user = Get.find<UserController>().userInfo.value;
    if (user == null) return;

    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: ZegoCallConfig.appId,
      appSign: ZegoCallConfig.appSign,
      userID: user.userId.toString(),
      userName: user.fullName.isEmpty ? user.email : user.fullName,
      plugins: [ZegoUIKitSignalingPlugin()],
    );

    _invitationServiceInitialized = true;
  }

  static void uninit() {
    if (!_invitationServiceInitialized) return;

    ZegoUIKitPrebuiltCallInvitationService().uninit();
    _invitationServiceInitialized = false;
  }
}
