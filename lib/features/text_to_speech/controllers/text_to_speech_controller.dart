import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechController extends GetxController{
  late File imageFile ;
  final ImagePicker _picker = ImagePicker();
  final textController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();

  /// Choose a photo from the gallery.
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      recognizeText();
    }
  }

  /// Choose a photo from the camera.
  Future<void> captureImage() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        recognizeText();
      }
    } else {
      Get.snackbar("Permission Denied", "Camera permission is required.");
    }
  }

  /// التعرف على النصوص باستخدام ML Kit
  Future<void> recognizeText() async {
    // if (imageFile == null) return;

    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFile(imageFile);

    try {
      final RecognizedText result = await textRecognizer.processImage(inputImage);
      textController.text = result.text.isNotEmpty ? result.text : "No text found";
    } catch (e) {
      textController.text = "No text found";
    } finally {
      textRecognizer.close();
    }
  }

  String detectLanguage(String text) {
    int arabicCount = 0;
    int englishCount = 0;

    for (int i = 0; i < text.length; i++) {
      if (RegExp(r'[\u0600-\u06FF]').hasMatch(text[i])) {
        arabicCount++;
      } else if (RegExp(r'[a-zA-Z]').hasMatch(text[i])) {
        englishCount++;
      }
    }

    if (arabicCount > englishCount) {
      return "ar-SA"; // العربية - السعودية
    } else if (englishCount > arabicCount) {
      return "en-US"; // الإنجليزية - الولايات المتحدة
    } else {
      return "mixed"; // خليط من اللغتين
    }
  }

  Future<void> textReading() async {
    String text = textController.text.trim();
    if (text.isEmpty) {
      Get.snackbar("خطأ", "لا يوجد نص للقراءة!");
      return;
    }

    String languageCode = detectLanguage(text);

    if (languageCode == "mixed") {
      Get.snackbar("تحذير", "النص يحتوي على لغتين، قد لا يكون النطق دقيقًا.");
    }

    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);
  }


}