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

  // Use the TTS service instead of creating a new FlutterTts instance
  final TtsService ttsService = TtsService.to;

  // Screen identifier
  final String screenName = 'text_to_speech';

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // OCR method selection
  RxString selectedOcrMethod = 'docflow'.obs; // 'docflow' or 'tesseract'

  @override
  void onInit() {
    super.onInit();
    // Set the current screen when this controller is initialized
    ttsService.setCurrentScreen(screenName);
  }

  /// اختيار طريقة OCR
  void selectOcrMethod(String method) {
    selectedOcrMethod.value = method;
    // يمكن حفظ التفضيل في التخزين المحلي إذا أردت
  }

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

  /// التعرف على النصوص باستخدام الطريقة المختارة
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

  /// التعرف على النص باستخدام DocFlow API
  Future<String> _recognizeTextWithDocFlow() async {
    final extractedDoc = await DocumentService.extractDocument(
      file: imageFile.value!,
    );

    if (extractedDoc != null &&
        extractedDoc.documents.isNotEmpty &&
        extractedDoc.documents[0].textAnnotation != null) {
      // استخراج النص من جميع الصفحات
      final pages = extractedDoc.documents[0].textAnnotation!.pages;

      // معالجة كل صفحة على حدة
      List<String> processedPages = [];

      for (var page in pages) {
        // تقسيم الصفحة إلى أسطر بناءً على الإحداثيات
        Map<double, List<String>> lineMap = {};

        for (var word in page.words) {
          // استخدام الإحداثي Y من الـ outline كمفتاح للسطر
          // نأخذ متوسط الإحداثي Y لتحسين دقة التجميع
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

        // معالجة كل سطر
        List<String> processedLines = [];

        // ترتيب الأسطر من أعلى إلى أسفل
        List<double> sortedKeys = lineMap.keys.toList()..sort();

        for (var key in sortedKeys) {
          List<String> line = lineMap[key]!;

          // تحديد ما إذا كان السطر عربيًا بشكل أساسي
          bool isLineMainlyArabic = _isMainlyArabic(line.join(' '));

          // عكس ترتيب الكلمات في السطر إذا كان عربيًا
          if (isLineMainlyArabic) {
            // ترتيب الكلمات من اليمين إلى اليسار مع الحفاظ على ترتيب الكلمات داخل السطر
            processedLines.add(line.reversed.join(' '));
          } else {
            processedLines.add(line.join(' '));
          }
        }

        // إضافة الصفحة المعالجة
        processedPages.add(processedLines.join('\n'));
      }

      return processedPages.join('\n\n');
    }
    return '';
  }

  /// التحقق مما إذا كان النص عربيًا بشكل أساسي
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

    // إذا كان أكثر من 50% من الأحرف عربية، نعتبر النص عربيًا بشكل أساسي
    return arabicCount > nonArabicCount;
  }

  /// التعرف على النص باستخدام Tesseract OCR
  Future<String> _recognizeTextWithTesseract() async {
    // تحديد اللغات التي سيتم دعمها
    String language = 'ara+eng'; // العربية والإنجليزية

    // استخدام مكتبة Tesseract للتعرف على النص
    String extractedText = await FlutterTesseractOcr.extractText(
      imageFile.value!.path,
      language: language,
      args: {
        "psm": "4", // نمط تقسيم الصفحة لتحسين النتائج
        "preserve_interword_spaces": "1",
      },
    );

    // إرجاع النص كما هو دون عكس (للتesseract)
    return extractedText;
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

    // Use the TTS service instead of the local FlutterTts instance
    await ttsService.speak(
      text: text,
      screenName: screenName,
      rate: 0.5,
      language: languageCode,
    );
  }

  /// إيقاف القراءة
  Future<void> stopReading() async {
    await ttsService.stopSpeaking();
  }

  /// مسح النص
  void clearText() {
    textController.text = '';
  }

  @override
  void onClose() {
    // Stop TTS if this controller's screen is speaking
    if (ttsService.isSpeakingForScreen(screenName)) {
      ttsService.stopSpeaking();
    }
    textController.dispose();
    super.onClose();
  }
}
