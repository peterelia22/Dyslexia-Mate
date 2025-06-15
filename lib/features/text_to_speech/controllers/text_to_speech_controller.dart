import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/tts_service/tts_dervice.dart';

class TextToSpeechController extends GetxController {
  Rx<File?> imageFile = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  final textController = TextEditingController();

  final TtsService ttsService = TtsService.to;

  final String screenName = 'text_to_speech';

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  RxString selectedOcrMethod = 'docflow'.obs;

  @override
  void onInit() {
    super.onInit();
    ttsService.setCurrentScreen(screenName);
  }

  void selectOcrMethod(String method) {
    selectedOcrMethod.value = method;
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> captureImage() async {
    try {
      var status = await Permission.camera.request();
      if (status.isGranted) {
        final pickedFile = await _picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          imageFile.value = File(pickedFile.path);
        }
      } else {
        _showSafeMessage("تم رفض الإذن", "إذن الكاميرا مطلوب للمتابعة");
      }
    } catch (e) {
      debugPrint("Error capturing image: $e");
    }
  }

  void _showSafeMessage(String title, String message) {
    try {
      if (Get.context != null && Get.overlayContext != null) {
        Get.snackbar(title, message);
      } else {
        debugPrint("$title: $message");
        errorMessage.value = message;
      }
    } catch (e) {
      debugPrint("Error showing message: $e");
      errorMessage.value = message;
    }
  }

  void clearImage() {
    imageFile.value = null;
    errorMessage.value = '';
  }

  Future<void> recognizeText() async {
    if (imageFile.value == null) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      String extractedText = '';

      if (selectedOcrMethod.value == 'docflow') {
        extractedText = await _recognizeTextWithDocFlow();
      } else {
        extractedText = await _recognizeTextWithTesseract();
      }

      if (extractedText.isNotEmpty) {
        textController.text = extractedText;
      } else {
        errorMessage.value = "لم يتم العثور على نص";
        _showSafeMessage("تنبيه", "لم يتم العثور على نص في الصورة");
      }
    } catch (e) {
      errorMessage.value = "خطأ أثناء معالجة الصورة: $e";
      _showSafeMessage("خطأ", "حدث خطأ أثناء معالجة الصورة");
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _recognizeTextWithDocFlow() async {
    final extractedDoc = await DocumentService.extractDocument(
      file: imageFile.value!,
    );

    if (extractedDoc != null &&
        extractedDoc.documents.isNotEmpty &&
        extractedDoc.documents[0].textAnnotation != null) {
      final pages = extractedDoc.documents[0].textAnnotation!.pages;

      List<String> processedPages = [];

      for (var page in pages) {
        Map<double, List<String>> lineMap = {};

        for (var word in page.words) {
          List<double> yCoords = [];
          for (int i = 1; i < word.outline.length; i += 2) {
            yCoords.add(word.outline[i]);
          }
          double avgY = yCoords.reduce((a, b) => a + b) / yCoords.length;
          double lineKey = (avgY / 10).round() * 10;

          if (!lineMap.containsKey(lineKey)) {
            lineMap[lineKey] = [];
          }

          lineMap[lineKey]!.add(word.text);
        }

        List<String> processedLines = [];

        List<double> sortedKeys = lineMap.keys.toList()..sort();

        for (var key in sortedKeys) {
          List<String> line = lineMap[key]!;

          bool isLineMainlyArabic = _isMainlyArabic(line.join(' '));

          if (isLineMainlyArabic) {
            processedLines.add(line.reversed.join(' '));
          } else {
            processedLines.add(line.join(' '));
          }
        }

        processedPages.add(processedLines.join('\n'));
      }

      return processedPages.join('\n\n');
    }
    return '';
  }

  bool _isMainlyArabic(String text) {
    int arabicCount = 0;
    int nonArabicCount = 0;

    for (int i = 0; i < text.length; i++) {
      if (RegExp(r'[\u0600-\u06FF]').hasMatch(text[i])) {
        arabicCount++;
      } else if (RegExp(r'[a-zA-Z0-9]').hasMatch(text[i])) {
        nonArabicCount++;
      }
    }

    return arabicCount > nonArabicCount;
  }

  Future<String> _recognizeTextWithTesseract() async {
    String language = 'ara+eng';

    String extractedText = await FlutterTesseractOcr.extractText(
      imageFile.value!.path,
      language: language,
      args: {
        "psm": "4",
        "preserve_interword_spaces": "1",
      },
    );

    return extractedText;
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
      return "ar-SA";
    } else if (englishCount > arabicCount) {
      return "en-US";
    } else {
      return "mixed";
    }
  }

  Future<void> textReading() async {
    String text = textController.text.trim();
    if (text.isEmpty) {
      _showSafeMessage("خطأ", "لا يوجد نص للقراءة!");
      return;
    }

    String languageCode = detectLanguage(text);

    if (languageCode == "mixed") {
      _showSafeMessage(
          "تحذير", "النص يحتوي على لغتين، قد لا يكون النطق دقيقًا.");
      languageCode = "ar-SA";
    }

    await ttsService.speak(
      text: text,
      screenName: screenName,
      rate: 0.5,
      language: languageCode,
    );
  }

  Future<void> stopReading() async {
    await ttsService.stopSpeaking();
  }

  void clearText() {
    textController.text = '';
  }

  @override
  void onClose() {
    if (ttsService.isSpeakingForScreen(screenName)) {
      ttsService.stopSpeaking();
    }
    textController.dispose();
    super.onClose();
  }
}
