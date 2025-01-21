import 'package:dyslexia_mate/core/constants/text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.icon,
    required this.hintText,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
      child: Container(
        width: 360,
        child: TextField(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Color(0xff3F3381)),
            hintText: hintText,
            hintStyle: TextStyles.hintText,
            hintTextDirection: TextDirection.rtl,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
