import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'agora_config.dart';

class AgoraAudioCallManager {
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

    await engine.enableAudio();

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          isJoined = true;
          print("Local user joined");
        },

        onUserJoined: (connection, uid, elapsed) {
          remoteUid = uid;
          print("Remote user joined: $uid");
        },

        onUserOffline: (connection, uid, reason) {
          remoteUid = null;
          print("Remote user left");
        },

        onLeaveChannel: (connection, stats) {
          isJoined = false;
          print("Call ended");
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
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
      ),
    );
  }

  Future muteMicrophone(bool mute) async {
    await engine.muteLocalAudioStream(mute);
  }

  Future enableSpeaker(bool enable) async {
    await engine.setEnableSpeakerphone(enable);
  }

  Future leaveCall() async {
    await engine.leaveChannel();
  }

  Future dispose() async {
    await engine.release();
  }
}
