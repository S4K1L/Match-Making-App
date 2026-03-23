import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/calling_controller.dart';
import 'package:flutter_extension/model/call_model.dart';
import 'package:flutter_extension/util/api_constant.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:get/get.dart';
import 'ongoing_call.dart'; // import your OngoignCall page

class CallReceiveScreen extends StatefulWidget {
  final CallModel call;
  final CallType type;

  const CallReceiveScreen({super.key, required this.call, required this.type});

  @override
  State<CallReceiveScreen> createState() => _CallReceiveScreenState();
}

class _CallReceiveScreenState extends State<CallReceiveScreen> {
  late final CallingController controller;

  @override
  void initState() {
    super.initState();
    // Reuse existing controller instance or create one if not yet registered
    controller = Get.isRegistered<CallingController>()
        ? Get.find<CallingController>()
        : Get.put(CallingController());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.cover),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  ApiConstant.BASE_URL_IMAGE + widget.call.callerProfilePic,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.call.callerFullName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text("Incoming call"),
              const Spacer(),
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// DECLINE
                    GestureDetector(
                      onTap: () {
                        controller.rejectCall();
                        Get.back(); // close the incoming call screen
                      },
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.call_end),
                      ),
                    ),
                    const SizedBox(width: 80),

                    /// ACCEPT
                    GestureDetector(
                      onTap: () async {
                        // Accept the call
                        await controller.acceptCall(
                          widget.call.callId,
                          widget.call.channel,
                          widget.type,
                        );

                        // Navigate to ongoing call page
                        Get.off(
                          () =>
                              OngoignCall(call: widget.call, type: widget.type),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.call),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
