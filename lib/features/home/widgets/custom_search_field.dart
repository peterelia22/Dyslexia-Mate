import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFEDEFF2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Icon(
              Icons.search,
              color: Color(0xFF3D3F49),
            ),
          ),
          Expanded(
            child: TextField(
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                hintTextDirection: TextDirection.rtl,
                border: InputBorder.none,
                hintText: '   ابحث عن نشاط أو تحدي ممتع.... ',
                hintStyle: TextStyle(
                  color: const Color(0xFF3D3F49),
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: const TextStyle(
                color: Color(0xFF3D3F49),
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
              onSubmitted: (value) {
                print('بحث عن: $value');
              },
            ),
          ),
        ],
      ),
    );
  }
}
