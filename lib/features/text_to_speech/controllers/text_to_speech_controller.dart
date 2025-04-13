import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/services/api_service.dart';

class TextToSpeechController extends GetxController {
  Rx<File?> imageFile = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  final textController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  /// اختيار صورة من المعرض
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

  /// التقاط صورة من الكاميرا
  Future<void> captureImage() async {
    try {
      var status = await Permission.camera.request();
      if (status.isGranted) {
        final pickedFile = await _picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          imageFile.value = File(pickedFile.path);
        }
      } else {
        // استخدام طريقة آمنة لعرض رسالة الخطأ
        _showSafeMessage("تم رفض الإذن", "إذن الكاميرا مطلوب للمتابعة");
      }
    } catch (e) {
      debugPrint("Error capturing image: $e");
    }
  }

  /// طريقة آمنة لعرض رسائل الخطأ
  void _showSafeMessage(String title, String message) {
    try {
      // التحقق بشكل آمن من وجود السياق
      if (Get.context != null && Get.overlayContext != null) {
        Get.snackbar(title, message);
      } else {
        // إذا لم يكن السياق متاحًا، نقوم بطباعة الرسالة في وحدة التحكم
        debugPrint("$title: $message");
        // تخزين رسالة الخطأ في المتغير
        errorMessage.value = message;
      }
    } catch (e) {
      debugPrint("Error showing message: $e");
      errorMessage.value = message;
    }
  }

  /// إزالة الصورة الحالية
  void clearImage() {
    imageFile.value = null;
    errorMessage.value = '';
  }

  /// التعرف على النصوص باستخدام خدمة ScanDocFlow
  Future<void> recognizeText() async {
    if (imageFile.value == null) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final extractedDoc = await DocumentService.extractDocument(
        file: imageFile.value!,
      );

      if (extractedDoc != null &&
          extractedDoc.documents.isNotEmpty &&
          extractedDoc.documents[0].textAnnotation != null) {
        // استخراج النص من جميع الكلمات المستخرجة
        final allWords = extractedDoc.documents[0].textAnnotation!.pages
            .expand((page) => page.words)
            .map((word) => word.text)
            .join(' ');

        if (allWords.isNotEmpty) {
          textController.text = allWords;
        } else {
          errorMessage.value = "لم يتم العثور على نص";
          _showSafeMessage("تنبيه", "لم يتم العثور على نص في الصورة");
        }
      } else {
        errorMessage.value = "فشل في استخراج النص";
        _showSafeMessage("خطأ", "فشل في استخراج النص من الصورة");
      }
    } catch (e) {
      errorMessage.value = "خطأ أثناء معالجة الصورة: $e";
      _showSafeMessage("خطأ", "حدث خطأ أثناء معالجة الصورة");
    } finally {
      isLoading.value = false;
    }
  }

  /// الكشف عن اللغة
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

  /// قراءة النص
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
      // في حالة المزيج، الأفضل استخدام العربية كافتراضي في منطقتنا
      languageCode = "ar-SA";
    }

    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);
  }

  /// إيقاف القراءة
  Future<void> stopReading() async {
    await flutterTts.stop();
  }

  /// مسح النص
  void clearText() {
    textController.text = '';
  }

  @override
  void onClose() {
    flutterTts.stop();
    textController.dispose();
    super.onClose();
  }
}
