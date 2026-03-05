import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'agora_config.dart';

class AgoraVideoCallManager {
  late final RtcEngine engine;

  int? remoteUid;

  bool isJoined = false;

  Future initialize() async {
    engine = createAgoraRtcEngine();

    await engine.initialize(
      RtcEngineContext(
        appId: AgoraConfig.appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    await engine.enableVideo();

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          isJoined = true;
          print("Local joined channel");
        },

        onUserJoined: (connection, uid, elapsed) {
          remoteUid = uid;
          print("Remote joined: $uid");
        },

        onUserOffline: (connection, uid, reason) {
          remoteUid = null;
          print("Remote left");
        },

        onLeaveChannel: (connection, stats) {
          isJoined = false;
          print("Call finished");
        },
      ),
    );
  }

  Future joinCall({
    required String channelId,
    required String token,
    required int uid,
  }) async {
    await engine.joinChannel(
      token: token,
      channelId: channelId,
      uid: uid,
      options: const ChannelMediaOptions(
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
      ),
    );
  }

  Future switchCamera() async {
    await engine.switchCamera();
  }

  Future muteVideo(bool mute) async {
    await engine.muteLocalVideoStream(mute);
  }

  Future muteMic(bool mute) async {
    await engine.muteLocalAudioStream(mute);
  }

  Future leaveCall() async {
    await engine.leaveChannel();
  }

  Future dispose() async {
    await engine.release();
  }

  RtcEngine get rtcEngine => engine;
}
