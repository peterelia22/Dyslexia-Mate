import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomFormField({super.key, this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        cursorColor: Colors.black,
        controller: controller,
        maxLines: 20,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 13),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: "أدخل النص....",
        ),
        validator: validator,
      ),
    );
  }
}
