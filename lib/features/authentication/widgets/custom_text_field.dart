import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dyslexia_mate/core/constants/text_styles.dart';

class CustomTextField extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;
  final bool isDate;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.hintText,
    this.isPassword = false,
    this.isDate = false,
    required this.controller,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
      child: SizedBox(
        width: 360,
        child: TextField(
          controller: widget.controller,
          textAlign: TextAlign.right,
          obscureText: widget.isPassword,
          readOnly: widget.isDate,
          onTap: widget.isDate ? () => _selectDate(context) : null,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: const Color(0xff3F3381)),
            hintText: widget.hintText,
            hintStyle: TextStyles.hintText,
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
