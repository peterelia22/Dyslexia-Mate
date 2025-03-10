import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';

class SpeechController extends GetxController {
  var speech = stt.SpeechToText();
  var isListening = false.obs;
  var text = 'اضغط على الميكروفون وابدأ التحدث'.obs;
  Timer? timeoutTimer;

  @override
  void onInit() {
    super.onInit();
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
        text.value = '...تكلم الآن';

        // بدء الاستماع
        speech.listen(
          onResult: (result) {
            text.value = result.recognizedWords;
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

        // مؤقت لإيقاف المايك بعد 4 ثواني بدون نتيجة
        timeoutTimer?.cancel();
        timeoutTimer = Timer(const Duration(seconds: 4), () {
          if (text.value == '...تكلم الآن') {
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
    text.value = 'اضغط على الميكروفون وابدأ التحدث';
    speech.stop();
    timeoutTimer?.cancel();
  }

  void copyToClipboard() {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text.value)).then((_) {});
    }
  }

  bool shouldShowCopyIcon() {
    return text.value.isNotEmpty &&
        text.value != 'اضغط على الميكروفون وابدأ التحدث' &&
        text.value != '...تكلم الآن';
  }
}
