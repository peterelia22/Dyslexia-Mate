import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/text_to_speech_controller.dart';

class TextToSpeechScreenFooter extends StatelessWidget {
  const TextToSpeechScreenFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TextToSpeechController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              controller.textReading();
            },
            icon: const Icon(
              Icons.volume_up,
              size: 40,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () async {
              await controller.pickImage();
              await controller.recognizeText();
            },
            icon: const Icon(
              Icons.camera_alt,
              size: 40,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
