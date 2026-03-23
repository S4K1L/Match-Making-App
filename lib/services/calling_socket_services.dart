import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:flutter_extension/controller/calling_controller.dart';
import 'package:flutter_extension/model/call_model.dart';
import 'package:flutter_extension/services/shared_prefs_service.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_extension/views/screen/Chat/ongoing_call.dart';
import 'package:flutter_extension/views/screen/Chat/receiver_screen.dart';

class CallSocketService extends GetxService {
  WebSocket? _socket;
  final AudioPlayer _incomingPlayer = AudioPlayer();

  bool _isDialogOpen = false;
  bool _isConnecting = false;

  Timer? _reconnectTimer;

  bool get isConnected => _socket != null;

  /// ================= INIT =================
  Future<void> initSocket() async {
    if (_socket != null || _isConnecting) {
      debugPrint("⚠️ Socket already initialized/connecting");
      return;
    }

    _isConnecting = true;

    try {
      final token = await SharedPrefsService.get("token");
      final url = "${ApiConstant.BASE_URL_SOCKET}$token";
      debugPrint("🔌 Connecting to socket...");

      _socket = await WebSocket.connect(url);

      debugPrint("✅ Socket connected");

      _socket!.listen(
        _handleEvent,
        onDone: _handleDisconnect,
        onError: (error) {
          debugPrint("❌ Socket error: $error");
          _handleDisconnect();
        },
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint("❌ Socket connection failed: $e");
      _scheduleReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  /// ================= EVENT HANDLER =================
  Future<void> _handleEvent(dynamic event) async {
    try {
      final data = jsonDecode(event);
      debugPrint("📩 Socket event: $data");

      final type = data["type"];
      final payload = data["data"] ?? {};

      switch (type) {
        case "incoming_call":
          await _onIncomingCall(payload);
          break;

        case "call_reject":
          await _onCallRejected();
          break;

        case "call_accepted":
          await _onCallAccepted(payload);
          break;

        case "call_end":
          await _onCallEnd();
          break;

        default:
          debugPrint("⚠️ Unknown socket event: $type");
      }
    } catch (e) {
      debugPrint("❌ Socket parse error: $e");
    }
  }

  /// ================= EVENT ACTIONS =================

  Future<void> _onIncomingCall(Map<String, dynamic> data) async {
    await _playIncomingSound();

    if (_isDialogOpen) return;

    final callModel = CallModel.fromJson(data);

    _isDialogOpen = true;

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: CallReceiveScreen(
          call: callModel,
          type: callModel.callType.toLowerCase() == "video"
              ? CallType.video
              : CallType.audio,
        ),
      ),
      barrierDismissible: false,
    ).then((_) => _isDialogOpen = false);
  }

  Future<void> _onCallRejected() async {
    await stopSound();
    _closeDialogIfOpen();
  }

  Future<void> _onCallAccepted(Map<String, dynamic> data) async {
    await stopSound();
    _closeDialogIfOpen();

    final callModel = CallModel.fromJson(data);

    Get.to(
      () => OngoignCall(
        call: callModel,
        type: data["call_type"] == "audio" ? CallType.audio : CallType.video,
      ),
    );
  }

  Future<void> _onCallEnd() async {
    await stopSound();
    _closeDialogIfOpen();

    if (Get.currentRoute != '/') {
      Get.back();
    }
  }

  /// ================= SOCKET SEND =================

  void send(Map<String, dynamic> data) {
    if (!isConnected) {
      debugPrint("⚠️ Cannot send, socket not connected");
      return;
    }

    _socket!.add(jsonEncode(data));
  }

  void callInviteWS({required String callId, required int targetUserId}) {
    send({
      "type": "call_invite",
      "call_id": callId,
      "target_user_id": targetUserId,
    });
  }

  void acceptCallWS({required String callId}) {
    send({"type": "call_accept", "call_id": callId});
  }

  void rejectCallWS({required String callId}) {
    send({"type": "call_reject", "call_id": callId});
  }

  void endCallWS({required String callId}) {
    send({"type": "call_end", "call_id": callId, "reason": "ended"});
  }

  /// ================= SOUND =================

  Future<void> _playIncomingSound() async {
    try {
      await _incomingPlayer.setReleaseMode(ReleaseMode.loop);
      await _incomingPlayer.play(AssetSource("sounds/incoming_call.mp3"));
    } catch (e) {
      debugPrint("❌ Sound play error: $e");
    }
  }

  Future<void> stopSound() async {
    try {
      await _incomingPlayer.stop();
    } catch (e) {
      debugPrint("❌ Sound stop error: $e");
    }
  }

  /// ================= HELPERS =================

  void _closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    _isDialogOpen = false;
  }

  void _handleDisconnect() {
    debugPrint("🔌 Socket disconnected");

    _socket = null;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();

    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      debugPrint("🔁 محاولة إعادة الاتصال (Reconnecting...)");
      initSocket();
    });
  }

  /// ================= CLEANUP =================

  Future<void> disposeSocket() async {
    await stopSound();

    try {
      await _socket?.close();
    } catch (_) {}

    _socket = null;
    _reconnectTimer?.cancel();
  }
}
