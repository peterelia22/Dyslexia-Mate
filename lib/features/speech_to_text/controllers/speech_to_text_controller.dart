import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';

class SpeechController extends GetxController {
  var speech = stt.SpeechToText();
  var isListening = false.obs;
  var text = ''.obs;
  Timer? timeoutTimer;

  final String defaultText = 'اضغط على الميكروفون وابدأ التحدث';
  final String listeningText = '...تكلم الآن';

  @override
  void onInit() {
    super.onInit();
    text.value = defaultText;
    initSpeech();
  }

  void initSpeech() async {
    bool available = await speech.initialize();
    if (!available) {
      text.value = 'التعرف على الكلام غير متاح';
    }
  }

  void listen() async {
    if (!isListening.value) {
      bool available = await speech.initialize();
      if (available) {
        isListening.value = true;
        text.value = listeningText;

        speech.listen(
          onResult: (result) {
            if (result.recognizedWords.isNotEmpty) {
              text.value = result.recognizedWords;
            }

            if (result.finalResult) {
              isListening.value = false;
              timeoutTimer?.cancel();
            }
          },
          localeId: "ar_SA",
          pauseFor: const Duration(seconds: 10),
          listenFor: const Duration(seconds: 30),
          partialResults: true,
        );

        timeoutTimer?.cancel();
        timeoutTimer = Timer(const Duration(seconds: 4), () {
          if (text.value == listeningText) {
            stopListening();
          }
        });
      }
    } else {
      stopListening();
    }
  }

  void stopListening() {
    isListening.value = false;

    if (text.value == listeningText || text.value.isEmpty) {
      text.value = defaultText;
    }

    speech.stop();
    timeoutTimer?.cancel();
  }

  void copyToClipboard() {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text.value));
    }
  }

  bool shouldShowCopyIcon() {
    return text.value.isNotEmpty &&
        text.value != defaultText &&
        text.value != listeningText;
  }
}
