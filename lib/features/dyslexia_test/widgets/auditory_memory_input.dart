import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../../core/widgets/custom_snackBar.dart';

class AuditoryMemoryInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled;
  final VoidCallback onSubmitted;
  final BuildContext parentContext;

  const AuditoryMemoryInput({
    super.key,
    required this.controller,
    required this.isEnabled,
    required this.onSubmitted,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'اكتب إجابتك هنا',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp),
          enabled: isEnabled,
        ),
        SizedBox(height: 16.h),
        ElevatedButton(
          onPressed: isEnabled
              ? () {
                  if (controller.text.trim().isNotEmpty) {
                    onSubmitted();
                  } else {
                    CustomSnackbar.show(
                      parentContext,
                      title: 'تنبيه',
                      message: 'يرجى إدخال إجابة قبل المتابعة',
                      contentType: ContentType.warning,
                    );
                  }
                }
              : null,
          child: Text(
            'تأكيد الإجابة',
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
      ],
    );
  }
}
