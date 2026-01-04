import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.color,
    this.textStyle,
    this.radius,
    this.margin = EdgeInsets.zero,
    required this.onTap,
    required this.text,
    this.loading = false,
    this.width,
    this.height,
  });

  final Function() onTap;
  final String text;
  final bool loading;
  final double? height;
  final double? width;
  final Color? color;
  final double? radius;
  final EdgeInsetsGeometry margin;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: GestureDetector(
        onTap: loading ? null : onTap,
        child: Container(
          height: height ?? 52.0,
          width: width ?? Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 24.0),
            gradient: const LinearGradient(
              colors: [Color(0xFF18433B), Color(0xFF0C312B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ElevatedButton(
            onPressed: loading ? () {} : onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 24.0),
              ),
              minimumSize: Size(width ?? Get.width, height ?? 52.0),
            ),
            child: loading
                ? const SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Text(
                    text,
                    style:
                        textStyle ??
                        AppStyles.h3(
                          fontWeight: FontWeight.w700,

                          color: Colors.white,
                        ),
                  ),
          ),
        ),
      ),
    );
  }
}
