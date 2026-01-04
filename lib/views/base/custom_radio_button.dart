import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;

  const CustomRadioButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value ? const Color(0xFF18433B) : null,
          border: Border.all(color: const Color(0xFF18433B), width: 2),
        ),
        child: Center(
          child: AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: value ? 1.0 : 0.0,
            curve: Curves.easeInOutBack,
            child: const SizedBox(),
          ),
        ),
      ),
    );
  }
}
