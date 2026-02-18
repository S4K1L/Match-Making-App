import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar(
  String? message, {
  bool isError = true,
  bool getXSnackBar = false,
}) {
  if (message != null && message.isNotEmpty) {
    if (getXSnackBar) {
      Get.showSnackbar(
        GetSnackBar(
          backgroundColor: isError ? Colors.red.shade400 : Colors.green,
          message: message,
          duration: const Duration(seconds: 3),
          snackStyle: SnackStyle.FLOATING,
          margin: EdgeInsets.all(10),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.horizontal,
          margin: EdgeInsets.only(right: 10, top: 10, bottom: 10, left: 10),
          duration: const Duration(seconds: 3),
          backgroundColor: isError ? Colors.red.shade400 : Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Text(message, style: const TextStyle(fontSize: 14)),
        ),
      );
    }
  }
}
