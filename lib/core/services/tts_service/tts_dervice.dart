import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

/// A singleton service to manage TTS across the entire app
class TtsService extends GetxService {
  static TtsService get to => Get.find<TtsService>();

  final FlutterTts flutterTts = FlutterTts();
  final RxBool isSpeaking = false.obs;
  final RxString currentScreen = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initTts();
  }

  Future<void> _initTts() async {
    flutterTts.setCompletionHandler(() {
      isSpeaking.value = false;
    });
  }

  /// Set the current screen to track which screen is using TTS
  void setCurrentScreen(String screenName) {
    // If screen changes while speaking, stop speaking
    if (currentScreen.value != screenName && isSpeaking.value) {
      stopSpeaking();
    }
    currentScreen.value = screenName;
  }

  /// Speak text with the given parameters
  Future<void> speak({
    required String text,
    required String screenName,
    double rate = 0.5,
    String language = "ar-SA",
    double volume = 1.0,
    double pitch = 1.0,
    Function? onStart,
    Function? onComplete,
    Function(String, int, int, String)? onProgress,
  }) async {
    // Stop any ongoing speech
    await stopSpeaking();

    // Set the current screen
    setCurrentScreen(screenName);

    // Configure TTS
    await flutterTts.setLanguage(language);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);

    // Set handlers if provided
    if (onProgress != null) {
      flutterTts.setProgressHandler(onProgress);
    }

    if (onComplete != null) {
      flutterTts.setCompletionHandler(() {
        isSpeaking.value = false;
        onComplete();
      });
    } else {
      flutterTts.setCompletionHandler(() {
        isSpeaking.value = false;
      });
    }

    // Start speaking
    isSpeaking.value = true;
    if (onStart != null) onStart();
    await flutterTts.speak(text);
  }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    if (isSpeaking.value) {
      await flutterTts.stop();
      isSpeaking.value = false;
    }
  }

  /// Check if TTS is speaking for a specific screen
  bool isSpeakingForScreen(String screenName) {
    return isSpeaking.value && currentScreen.value == screenName;
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
