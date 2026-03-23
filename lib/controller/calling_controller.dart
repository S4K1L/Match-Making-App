import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_extension/model/agora_token_model.dart';
import 'package:flutter_extension/services/calling_socket_services.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/agora_service.dart';
import '../services/api_service.dart';
import '../util/api_constant.dart';

enum CallType { audio, video }

enum CallState { ringing, connecting, connected, ended }

class CallingController extends GetxController {
  final callingService = Get.find<CallSocketService>();
  final ApiService _apiService = ApiService();
  final AgoraService _agora = AgoraService();
  final AudioPlayer _ringPlayer = AudioPlayer();

  RtcEngine? get agoraEngine => _agora.engine;

  final Rx<CallState> callState = CallState.ringing.obs;
  final RxInt remoteUid = 0.obs;
  final RxInt callDuration = 0.obs;
  final RxBool isMute = false.obs;
  final RxBool isSpeaker = false.obs;
  final RxBool isEngineReady = false.obs;

  Timer? _timer;
  WebSocket? socket;

  String? callId;
  String? channelId;
  CallType? callType;

  bool _agoraInitialized = false;

  Future<void> _initializeAgora(CallType type) async {
    if (_agoraInitialized) return;

    await _agora.init(ApiConstant.AGORA_APP_ID);

    if (type == CallType.video) {
      await _agora.enableVideo();
      await _agora.engine?.startPreview();
    }

    _agora.engine?.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (_, uid, __) {
          remoteUid.value = uid;
          callState.value = CallState.connected;
          _stopRingtone();
          _startTimer();
        },
        onUserOffline: (_, __, ___) {
          endCall();
        },
      ),
    );

    _agoraInitialized = true;
    isEngineReady.value = true;
  }

  Future<AgoraTokenResponse> getCallToken(String channelId) async {
    final response = await _apiService.get(
      "call/agora-token/?channel=$channelId",
      authReq: true,
    );
    final body = jsonDecode(response.body);
    final data = body["data"];
    return AgoraTokenResponse.fromJson(data);
  }

  Future<void> startCall(String receiverId, CallType type) async {
    callType = type;
    callState.value = CallState.ringing;

    await _requestPermissions(type);
    await _playRingtone();

    final response = await _apiService.post("call/start/", {
      "receiver_id": int.parse(receiverId),
      "call_type": type == CallType.audio ? "audio" : "video",
    }, authReq: true);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      final data = body["data"];

      callId = data["call_id"];
      channelId = data["channel"];

      final tokenResponse = await getCallToken(channelId!);

      callingService.callInviteWS(
        callId: callId.toString(),
        targetUserId: int.parse(receiverId),
      );

      await _initializeAgora(type);
      await _agora.joinChannel(
        channelId!,
        tokenResponse.token,
        tokenResponse.uid,
      );
    } else if (response.statusCode == 409) {
      showCustomSnackBar("Call already in progress", isError: true);
      Get.back();
    }
  }

  Future<void> acceptCall(String id, String channel, CallType type) async {
    callType = type;
    callId = id;
    channelId = channel;

    callState.value = CallState.connecting;

    await _requestPermissions(type);
    await _stopRingtone();

    final response = await _apiService.post(
      "call/$id/accept/",
      {},
      authReq: true,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final tokenResponse = await getCallToken(channel);

      callingService.acceptCallWS(callId: callId.toString());

      await _initializeAgora(type);

      await _agora.joinChannel(channel, tokenResponse.token, tokenResponse.uid);
    } else {
      debugPrint("Accept call API error: $response");
    }
  }

  Future<void> endCall() async {
    callState.value = CallState.ended;

    _stopTimer();
    await _stopRingtone();

    try {
      if (callId != null) {
        await _apiService.post("call/$callId/end/", {}, authReq: true);
        callingService.endCallWS(callId: callId.toString());
      }
    } catch (e) {
      debugPrint("End call API error: $e");
    }

    try {
      await socket?.close();
    } catch (_) {}
    try {
      await _agora.leaveChannel();
    } catch (_) {}
    try {
      _agora.dispose();
    } catch (_) {}

    _agoraInitialized = false;

    await Future.delayed(const Duration(milliseconds: 500));

    if (Get.isRegistered<CallingController>()) {
      Get.back();
    }
  }

  Future<void> rejectCall() async {
    callState.value = CallState.ended;

    _stopTimer();
    await _stopRingtone();

    try {
      if (callId != null) {
        final response = await _apiService.post(
          "call/$callId/reject/",
          {},
          authReq: true,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          callingService.rejectCallWS(callId: callId.toString());
        } else {
          debugPrint("End call API error: $response");
        }
      }
    } catch (e) {
      debugPrint("End call API error: $e");
    }

    try {
      await socket?.close();
    } catch (_) {}
    try {
      await _agora.leaveChannel();
    } catch (_) {}
    try {
      _agora.dispose();
    } catch (_) {}

    _agoraInitialized = false;

    await Future.delayed(const Duration(milliseconds: 500));

    if (Get.isRegistered<CallingController>()) {
      Get.back();
    }
  }

  Future<void> _requestPermissions(CallType type) async {
    await Permission.microphone.request();

    if (type == CallType.video) {
      await Permission.camera.request();
    }
  }

  Future<void> _playRingtone() async {
    await _ringPlayer.setReleaseMode(ReleaseMode.loop);
    await _ringPlayer.play(AssetSource("sounds/calling.mp3"));
  }

  Future<void> _stopRingtone() async {
    await _ringPlayer.stop();
  }

  void toggleMute() {
    isMute.toggle();
    _agora.toggleMute(isMute.value);
  }

  void toggleSpeaker() {
    isSpeaker.toggle();
    _agora.enableSpeaker(isSpeaker.value);
  }

  void _startTimer() {
    _timer?.cancel();
    callDuration.value = 0;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => callDuration.value++,
    );
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String get formattedTime {
    final minutes = callDuration.value ~/ 60;
    final seconds = callDuration.value % 60;

    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void onClose() {
    _stopTimer();
    socket?.close();
    _ringPlayer.dispose();
    _agora.dispose();
    _agoraInitialized = false;
    isEngineReady.value = false;

    super.onClose();
  }
}
