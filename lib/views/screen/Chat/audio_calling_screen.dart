import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/calling_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AudioCallingScreen extends StatefulWidget {
  final String id;
  final String image;
  final String name;
  const AudioCallingScreen({
    super.key,
    required this.id,
    required this.image,
    required this.name,
  });

  @override
  State<AudioCallingScreen> createState() => _AudioCallingScreenState();
}

class _AudioCallingScreenState extends State<AudioCallingScreen> {
  final CallingController callingController = Get.put(CallingController());

  @override
  void initState() {
    callingController.startCall(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),

          SafeArea(child: Column(children: [_header()])),

          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.image),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.name,
                  style: const TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Text(
                    callingController.isReceived.value
                        ? callingController.formattedTime
                        : "Calling...",
                    style: const TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 55,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      callingController.toggleSpeaker();
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: callingController.isLoudSpeaker.value
                          ? AppColors.primaryColor
                          : Colors.white,
                      child: SvgPicture.asset(
                        'assets/icons/speaker.svg',
                        color: callingController.isLoudSpeaker.value
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 32),
                GestureDetector(
                  onTap: () {
                    callingController.stopTimer();
                    Get.back();
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryColor,
                    child: SvgPicture.asset('assets/icons/calling.svg'),
                  ),
                ),
                SizedBox(width: 32),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      callingController.toggleMute();
                    },
                    child: CircleAvatar(
                      radius: 24,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          InkWell(
            onTap: Get.back,
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
}
