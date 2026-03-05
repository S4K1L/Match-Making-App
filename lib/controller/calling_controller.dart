import 'dart:async';
import 'package:flutter_extension/services/api_service.dart';
import 'package:get/get.dart';

class CallingController extends GetxController {
  final ApiService _apiService = ApiService();

  RxBool isReceived = false.obs;
  RxBool isMute = false.obs;
  RxBool isLoudSpeaker = false.obs;

  RxInt callDuration = 0.obs;

  Timer? _timer;

  void toggleMute() {
    isMute.value = !isMute.value;
  }

  void toggleSpeaker() {
    isLoudSpeaker.value = !isLoudSpeaker.value;
  }

  Future<void> startCall(String receiverId) async {
    // simulate receiver accept
    Future.delayed(const Duration(seconds: 5), () {
      isReceived.value = true;
      startTimer();
    });

    // await _apiService.startCall(receiverId);
  }

  void startTimer() {
    callDuration.value = 0;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callDuration.value++;
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  String get formattedTime {
    int hours = callDuration.value ~/ 3600;
    int minutes = (callDuration.value % 3600) ~/ 60;
    int seconds = callDuration.value % 60;

    return "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void onClose() {
    stopTimer();
    super.onClose();
  }
}
