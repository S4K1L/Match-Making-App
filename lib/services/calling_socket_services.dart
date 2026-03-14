import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_extension/controller/calling_controller.dart';
import 'package:flutter_extension/model/call_model.dart';
import 'package:flutter_extension/services/shared_prefs_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_extension/views/screen/Chat/receiver_screen.dart';
import 'package:get/get.dart';

class CallSocketService extends GetxService {
  WebSocket? socket;
  final AudioPlayer _incomingPlayer = AudioPlayer();

  Future<void> initSocket() async {
    final token = await SharedPrefsService.get("token");

    socket = await WebSocket.connect("${ApiConstant.BASE_URL_SOCKET}$token");

    socket!.listen((event) async {
      final data = jsonDecode(event);

      if (data["type"] == "incoming_call") {
        await _playIncomingSound();

        // Parse the CallModel from the 'data' field
        final callModel = CallModel.fromJson(data["data"] ?? {});

        _showIncomingPopup(callModel);
      }
    });
  }

  Future<void> _playIncomingSound() async {
    await _incomingPlayer.setReleaseMode(ReleaseMode.loop);
    await _incomingPlayer.play(AssetSource("sounds/incoming_call.mp3"));
  }

  Future<void> stopSound() async {
    await _incomingPlayer.stop();
  }

  void _showIncomingPopup(CallModel callModel) {
    Get.dialog(
      CallReceiveScreen(
        call: callModel,
        type: callModel.callType.toLowerCase() == "video"
            ? CallType.video
            : CallType.audio,
      ),
      barrierDismissible: false,
    );
  }
}
