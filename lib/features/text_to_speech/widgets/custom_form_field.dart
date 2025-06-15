import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/text_to_speech_controller.dart';
import 'shimmer_loading.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomFormField({super.key, this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    final TextToSpeechController speechController =
        Get.find<TextToSpeechController>();

    return Obx(() {
      if (speechController.isLoading.value) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          height: 350,
          padding: const EdgeInsets.all(16),
          child: const ShimmerLoading(),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(8),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            cursorColor: Colors.black,
            controller: controller,
            maxLines: 22,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 13, horizontal: 10),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: "أدخل النص أو التقط صورة...",
              hintStyle: TextStyle(color: Colors.grey),
            ),
            validator: validator,
          ),
        ),
      );
    });
  }
}
