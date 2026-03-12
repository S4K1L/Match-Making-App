import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/calling_controller.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:get/get.dart';

class CallReceiveScreen extends StatefulWidget {
  final String id;
  final String channel;
  final String name;
  final String image;
  final CallType type;

  const CallReceiveScreen({
    super.key,
    required this.id,
    required this.channel,
    required this.name,
    required this.image,
    required this.type,
  });

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
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.image),
              ),

              const SizedBox(height: 12),

              Text(
                widget.name,
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
                        widget.id,
                        widget.channel,
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
