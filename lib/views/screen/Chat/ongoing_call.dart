import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/calling_controller.dart';
import 'package:flutter_extension/model/call_model.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OngoignCall extends StatefulWidget {
  final CallModel call;
  final CallType type;

  const OngoignCall({super.key, required this.call, required this.type});

  @override
  State<OngoignCall> createState() => _OngoignCallState();
}

class _OngoignCallState extends State<OngoignCall> {
  late final CallingController callingController;

  @override
  void initState() {
    super.initState();
    // Reuse existing controller or create a new one
    callingController = Get.isRegistered<CallingController>()
        ? Get.find<CallingController>()
        : Get.put(CallingController());
  }

  @override
  void dispose() {
    // Do NOT call endCall() here — it calls Get.back() internally causing double-pop.
    // The controller's onClose() handles cleanup (leave channel, release engine).
    // Let GetX handle the controller lifecycle.
    super.dispose();
  }

  Widget _buildBody() {
    return widget.type == CallType.video ? _videoView() : _audioView();
  }

  Widget _audioView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
            ApiConstant.BASE_URL_IMAGE + widget.call.callerProfilePic,
          ),
        ),
        const SizedBox(height: 10),
        Text(widget.call.callerFullName),
        const SizedBox(height: 8),
        Obx(() {
          switch (callingController.callState.value) {
            case CallState.connected:
              return Text(callingController.formattedTime);
            case CallState.connecting:
              return const Text("Connecting...");
            case CallState.ringing:
              return const Text("Calling...");
            case CallState.ended:
              return const Text("Call ended");
          }
        }),
      ],
    );
  }

  Widget _videoView() {
    return Stack(
      children: [
        Obx(() {
          if (!callingController.isEngineReady.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (callingController.remoteUid.value != 0) {
            return AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: callingController.agoraEngine!,
                canvas: VideoCanvas(uid: callingController.remoteUid.value),
                connection: RtcConnection(
                  channelId: callingController.channelId!,
                ),
              ),
            );
          }

          return const Center(child: Text("Waiting for user"));
        }),

        // local video preview
        Positioned(
          right: 20,
          top: 100,
          child: SizedBox(
            width: 120,
            height: 160,
            child: Obx(() {
              if (!callingController.isEngineReady.value)
                return const SizedBox();
              return AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: callingController.agoraEngine!,
                  canvas: const VideoCanvas(uid: 0),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _controls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () => GestureDetector(
            onTap: callingController.toggleSpeaker,
            child: CircleAvatar(
              backgroundColor: callingController.isSpeaker.value
                  ? AppColors.primaryColor
                  : Colors.white,
              child: SvgPicture.asset(
                'assets/icons/speaker.svg',
                color: callingController.isSpeaker.value
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 32),
        GestureDetector(
          onTap: callingController.endCall,
          child: const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.red,
            child: Icon(Icons.call_end),
          ),
        ),
        const SizedBox(width: 32),
        Obx(
          () => GestureDetector(
            onTap: callingController.toggleMute,
            child: CircleAvatar(
              backgroundColor: callingController.isMute.value
                  ? AppColors.primaryColor
                  : Colors.white,
              child: SvgPicture.asset(
                'assets/icons/mute.svg',
                color: callingController.isMute.value
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          InkWell(
            onTap: callingController.endCall,
            child: const Icon(Icons.arrow_back_ios, color: Color(0xFF707270)),
          ),
          const Spacer(),
          const SizedBox(width: 24),
          const Spacer(),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                _header(),
                Expanded(child: _buildBody()),
                const SizedBox(height: 40),
                _controls(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
