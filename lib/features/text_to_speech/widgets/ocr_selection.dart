import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/text_to_speech_controller.dart';

class OcrMethodSelector extends StatelessWidget {
  const OcrMethodSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TextToSpeechController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "اختر طريقة التعرف على النص:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 10),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMethodOption(
                    controller,
                    'docflow',
                    'DocFlow API',
                    'الأكثر دقة للغة العربية',
                    Icons.cloud_outlined,
                    Colors.blue,
                  ),
                  _buildMethodOption(
                    controller,
                    'tesseract',
                    'Tesseract OCR',
                    'يعمل بدون إنترنت',
                    Icons.phone_android,
                    Colors.green,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildMethodOption(
    TextToSpeechController controller,
    String value,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () => controller.selectOcrMethod(value),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: controller.selectedOcrMethod.value == value
                ? color.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: controller.selectedOcrMethod.value == value
                  ? color
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: controller.selectedOcrMethod.value == value
                    ? color
                    : Colors.grey,
                size: 30,
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: controller.selectedOcrMethod.value == value
                      ? color
                      : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: controller.selectedOcrMethod.value == value
                      ? color
                      : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
