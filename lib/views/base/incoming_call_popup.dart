import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/calling_controller.dart';
import 'package:flutter_extension/views/screen/Chat/receiver_screen.dart';
import 'package:get/get.dart';

class IncomingCallPopup extends StatelessWidget {
  final Map data;

  const IncomingCallPopup({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final callerName = data["caller_name"];
    final callerImage = data["caller_image"];

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(callerImage),
            ),

            const SizedBox(height: 10),

            Text(
              callerName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.red),
                  onPressed: () {
                    Get.back();
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.call, color: Colors.green),
                  onPressed: () {
                    Get.back();

                    Get.to(
                      () => CallReceiveScreen(
                        id: data["call_id"],
                        channel: data["channel"],
                        name: callerName,
                        image: callerImage,
                        type: data["call_type"] == "video"
                            ? CallType.video
                            : CallType.audio,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
