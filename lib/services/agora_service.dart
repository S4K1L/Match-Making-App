import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';

class AgoraService {
  RtcEngine? engine;
  bool engineCreated = false;

  Future<void> init(String appId) async {
    if (engineCreated) return;
    engine = createAgoraRtcEngine();

    try {
      await engine?.initialize(RtcEngineContext(appId: appId));
    } catch (e) {
      debugPrint("Agora initialize error: $e");
      return;
    }

    /// required for 1-to-1 calling
    await engine?.setChannelProfile(
      ChannelProfileType.channelProfileCommunication,
    );

    await engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await engine?.enableAudio();

    /// better audio configuration for calling
    await engine?.setAudioProfile(
      profile: AudioProfileType.audioProfileSpeechStandard,
      scenario: AudioScenarioType.audioScenarioDefault,
    );

    /// enable speakerphone by default so both sides can hear each other
    try {
      await engine?.setEnableSpeakerphone(true);
    } catch (e) {
      debugPrint("Agora default speaker error: $e");
    }

    engineCreated = true;
  }

  Future<void> enableVideo() async {
    await engine?.enableVideo();
    await engine?.startPreview();
  }

  Future<void> joinChannel(String channelId, String token, int uid) async {
    await engine?.joinChannel(
      token: token,
      channelId: channelId,
      uid: uid,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
      ),
    );
  }

  Future<void> leaveChannel() async {
    await engine?.leaveChannel();
  }

  Future<void> toggleMute(bool mute) async {
    await engine?.muteLocalAudioStream(mute);
  }

  Future<void> enableSpeaker(bool enable) async {
    try {
      await engine?.setEnableSpeakerphone(enable);
    } catch (e) {
      debugPrint("Agora enableSpeaker error: $e");
    }
  }

  Future<void> switchCamera() async {
    await engine?.switchCamera();
  }

  void dispose() {
    engine?.release();
    engine = null;
    engineCreated = false;
  }
}
