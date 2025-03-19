import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
          SpeedDial(
            icon: Icons.camera_alt,
            activeIcon: Icons.close,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            activeBackgroundColor: Colors.red,
            activeForegroundColor: Colors.white,
            buttonSize: Size(60, 60),
            childrenButtonSize: Size(55, 55),
            elevation: 8.0,
            overlayColor: Colors.black,
            overlayOpacity: 0.3,
            spaceBetweenChildren: 10,
            children: [
              SpeedDialChild(
                child: Icon(Icons.camera, color: Colors.blue),
                backgroundColor: Colors.white,
                label: 'التقط صورة',
                labelStyle: TextStyle(fontSize: 14),
                onTap: () async {
                  await controller.captureImage();
                  await controller.recognizeText();
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.photo_library, color: Colors.green),
                backgroundColor: Colors.white,
                label: 'اختر من المعرض',
                labelStyle: TextStyle(fontSize: 14),
                onTap: () async {
                  await controller.pickImage();
                  await controller.recognizeText();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
