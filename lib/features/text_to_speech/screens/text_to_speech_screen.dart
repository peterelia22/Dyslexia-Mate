import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/text_to_speech_controller.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/ocr_selection.dart';
import '../widgets/text_to_speech_screen_footer.dart';

class TextToSpeechScreen extends StatelessWidget {
  const TextToSpeechScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextToSpeechController controller = Get.put(TextToSpeechController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF7AD1F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 75),
                  Obx(() => controller.imageFile.value != null
                      ? Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              width: double.infinity,
                              constraints: const BoxConstraints(
                                  maxHeight: 200), // تحديد ارتفاع أقصى للصورة
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white, // إضافة خلفية بيضاء
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  controller.imageFile.value!,
                                  fit: BoxFit.contain, // عرض الصورة كاملة
                                ),
                              ),
                            ),
                            // زر إزالة الصورة - معطل أثناء التحميل
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Obx(() => InkWell(
                                    onTap: controller.isLoading.value
                                        ? null
                                        : () {
                                            controller.clearImage();
                                          },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: controller.isLoading.value
                                            ? Colors
                                                .grey // لون رمادي عندما يكون معطلاً
                                            : Colors.red,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        )
                      : const SizedBox()),
                  CustomFormField(controller: controller.textController),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // إضافة شاشة اختيار طريقة OCR
            const OcrMethodSelector(),
            const SizedBox(height: 10),
            const TextToSpeechScreenFooter(),
            const SizedBox(height: 30),
            // عرض رسالة الخطأ إذا وجدت
            Obx(() => controller.errorMessage.value.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
