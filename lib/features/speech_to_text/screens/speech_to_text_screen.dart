import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/speech_to_text_controller.dart';

class SpeechToTextScreen extends StatelessWidget {
  const SpeechToTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SpeechController speechController = Get.put(SpeechController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Container(
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 75),
                  Obx(() => Text(
                        speechController.text.value,
                        style: const TextStyle(
                          fontFamily: 'maqroo',
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.right,
                      )),
                  const Spacer(),
                  Obx(() {
                    if (speechController.shouldShowCopyIcon()) {
                      return Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                          icon: const Icon(Icons.copy, color: Colors.black),
                          onPressed: speechController.copyToClipboard,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: speechController.isListening.value ? 120 : 80,
                height: speechController.isListening.value ? 120 : 80,
                decoration: BoxDecoration(
                  color: speechController.isListening.value
                      ? const Color(0xff0A1C3D)
                      : const Color(0xffCBA2EA),
                  shape: BoxShape.circle,
                  boxShadow: speechController.isListening.value
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            spreadRadius: 10,
                            blurRadius: 20,
                            offset: const Offset(0, 0),
                          )
                        ]
                      : null,
                ),
                child: IconButton(
                  icon: Icon(
                    speechController.isListening.value
                        ? Icons.mic
                        : Icons.mic_none,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: speechController.listen,
                ),
              )),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
