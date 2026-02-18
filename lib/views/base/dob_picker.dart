import 'package:flutter/material.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_svg/svg.dart';

class DOBTextField extends StatelessWidget {
  final TextEditingController controller;

  const DOBTextField({super.key, required this.controller});

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18), // default 18 years old
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: CustomTextField(
          controller: controller,
          hintText: "DD/MM/YY".toUpperCase(),
          filColor: Colors.white,
          filled: true,
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
            child: SvgPicture.asset('assets/icons/calender.svg'),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select date of birth";
            }
            return null;
          },
        ),
      ),
    );
  }
}
