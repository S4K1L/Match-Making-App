import 'package:flutter/material.dart';
import 'package:get/get.dart';

customAppBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Row(
      children: [
        InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios, color: Color(0xFF2A2D2A)),
        ),
        Text(
          "Back".toLowerCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF2A2D2A),
          ),
        ),
      ],
    ),
  );
}
