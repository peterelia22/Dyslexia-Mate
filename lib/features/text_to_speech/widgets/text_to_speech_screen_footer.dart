import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import '../controllers/text_to_speech_controller.dart';

class TextToSpeechScreenFooter extends StatelessWidget {
  const TextToSpeechScreenFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TextToSpeechController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Row(
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
              const SizedBox(width: 15),
              IconButton(
                onPressed: () {
                  controller.stopReading();
                },
                icon: const Icon(
                  Icons.stop_circle,
                  size: 40,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 15),
              IconButton(
                onPressed: () {
                  controller.clearText();
                },
                icon: const Icon(
                  Icons.delete_outline,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Obx(
            () => controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.black)
                : SpeedDial(
                    icon: Icons.camera_alt,
                    activeIcon: Icons.close,
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    activeBackgroundColor: Colors.red,
                    activeForegroundColor: Colors.white,
                    buttonSize: const Size(60, 60),
                    childrenButtonSize: const Size(55, 55),
                    elevation: 8.0,
                    overlayColor: Colors.black,
                    overlayOpacity: 0.3,
                    spaceBetweenChildren: 10,
                    children: [
                      SpeedDialChild(
                        child: const Icon(Icons.camera, color: Colors.blue),
                        backgroundColor: Colors.white,
                        label: 'التقط صورة',
                        labelStyle: const TextStyle(fontSize: 14),
                        onTap: () async {
                          await controller.captureImage();
                          if (controller.imageFile.value != null) {
                            await controller.recognizeText();
                          }
                        },
                      ),
                      SpeedDialChild(
                        child: const Icon(Icons.photo_library,
                            color: Colors.green),
                        backgroundColor: Colors.white,
                        label: 'اختر من المعرض',
                        labelStyle: const TextStyle(fontSize: 14),
                        onTap: () async {
                          await controller.pickImage();
                          if (controller.imageFile.value != null) {
                            await controller.recognizeText();
                          }
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
