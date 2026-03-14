import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/calling_controller.dart';
import 'package:flutter_extension/model/call_model.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:get/get.dart';

class CallReceiveScreen extends StatefulWidget {
  final CallModel call;
  final CallType type;

  const CallReceiveScreen({super.key, required this.call, required this.type});

  @override
  State<CallReceiveScreen> createState() => _CallReceiveScreenState();
}

class _CallReceiveScreenState extends State<CallReceiveScreen> {
  final CallingController controller = Get.put(CallingController());

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
              // Display caller image
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.call.callerProfilePic),
              ),

              const SizedBox(height: 12),

              // Display caller name
              Text(
                widget.call.callerFullName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),
              const Text("Incoming call"),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// DECLINE
                  GestureDetector(
                    onTap: () {
                      controller.endCall();
                    },
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.call_end),
                    ),
                  ),

                  const SizedBox(width: 40),

                  /// ACCEPT
                  GestureDetector(
                    onTap: () async {
                      await controller.acceptCall(
                        widget.call.callId,
                        widget.call.channel,
                        widget.type,
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
            ],
          ),
        ],
      ),
    );
  }
}
