import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/text_to_speech_controller.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/text_to_speech_screen_footer.dart';

class TextToSpeechScreen extends StatelessWidget {
  const TextToSpeechScreen({super.key});

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
                  CustomFormField(controller: controller.textController,)
                ],
              ),
            ),
            const SizedBox(height: 20),
            const TextToSpeechScreenFooter(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
