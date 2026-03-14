// import 'package:flutter/material.dart';
// import 'package:flutter_extension/controller/calling_controller.dart';
// import 'package:flutter_extension/model/call_model.dart';
// import 'package:flutter_extension/util/api_constant.dart';
// import 'package:flutter_extension/views/screen/Chat/receiver_screen.dart';
// import 'package:get/get.dart';

// class IncomingCallPopup extends StatelessWidget {
//   final CallModel callModel;

//   const IncomingCallPopup({super.key, required this.callModel});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircleAvatar(
//               radius: 40,
//               backgroundImage: NetworkImage(
//                 ApiConstant.BASE_URL + callModel.callerProfilePic,
//               ),
//             ),

//             const SizedBox(height: 10),

//             Text(
//               callModel.callerFullName,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 20),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.call_end, color: Colors.red),
//                   onPressed: () {
//                     Get.back();
//                   },
//                 ),

//                 IconButton(
//                   icon: const Icon(Icons.call, color: Colors.green),
//                   onPressed: () {
//                     Get.back();

//                     Get.to(
//                       () => CallReceiveScreen(
//                         id: callModel.callId,
//                         channel: callModel.channel,
//                         name: callModel.callerFullName,
//                         image: callModel.callerProfilePic,
//                         type: callModel.callType == "video"
//                             ? CallType.video
//                             : CallType.audio,
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
