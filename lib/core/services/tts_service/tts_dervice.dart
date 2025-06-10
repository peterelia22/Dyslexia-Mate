import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'dart:async';

/// A singleton service to manage TTS across the entire app
class TtsService extends GetxService {
  static TtsService get to => Get.find<TtsService>();

  final FlutterTts flutterTts = FlutterTts();
  final RxBool isSpeaking = false.obs;
  final RxString currentScreen = ''.obs;
  bool _isDisposed = false;

  // Add a completer to track ongoing TTS operations
  Completer<void>? _activeOperation;
  Timer? _timeoutTimer;

  @override
  void onInit() {
    super.onInit();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      // Initialize TTS engine
      await flutterTts.setSharedInstance(true);

      // Set completion handler
      flutterTts.setCompletionHandler(() {
        if (!_isDisposed) {
          isSpeaking.value = false;
          _completeActiveOperation();
        }
      });

      // Set error handler
      flutterTts.setErrorHandler((msg) {
        print("TTS Error: $msg");
        if (!_isDisposed) {
          isSpeaking.value = false;
          _completeActiveOperation();
        }
      });

      // Set cancel handler
      flutterTts.setCancelHandler(() {
        if (!_isDisposed) {
          isSpeaking.value = false;
          _completeActiveOperation();
        }
      });
    } catch (e) {
      print('Error initializing TTS: $e');
    }
  }

  void _completeActiveOperation() {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;

    if (_activeOperation != null && !_activeOperation!.isCompleted) {
      _activeOperation!.complete();
    }
    _activeOperation = null;
  }

  /// Set the current screen to track which screen is using TTS
  void setCurrentScreen(String screenName) {
    if (_isDisposed) return;

    try {
      // If screen changes while speaking, stop speaking
      if (currentScreen.value != screenName && isSpeaking.value) {
        stopSpeaking();
      }
      currentScreen.value = screenName;
    } catch (e) {
      print('Error setting current screen: $e');
    }
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
    if (_isDisposed || text.trim().isEmpty) return;

    try {
      // Stop any ongoing speech and wait for it to complete
      await stopSpeaking();

      // Create a new operation tracker
      _activeOperation = Completer<void>();

      // Set the current screen
      setCurrentScreen(screenName);

      // Configure TTS
      await flutterTts.setLanguage(language);
      await flutterTts.setSpeechRate(rate);
      await flutterTts.setVolume(volume);
      await flutterTts.setPitch(pitch);

      // Set handlers
      if (onProgress != null) {
        flutterTts.setProgressHandler(onProgress);
      }

      // Set completion handler with custom callback
      flutterTts.setCompletionHandler(() {
        if (!_isDisposed) {
          isSpeaking.value = false;
          if (onComplete != null) {
            try {
              onComplete();
            } catch (e) {
              print('Error in onComplete callback: $e');
            }
          }
          _completeActiveOperation();
        }
      });

      // Start speaking
      if (!_isDisposed) {
        isSpeaking.value = true;
        if (onStart != null) {
          try {
            onStart();
          } catch (e) {
            print('Error in onStart callback: $e');
          }
        }

        // Set a timeout timer as a safety net
        _timeoutTimer = Timer(Duration(seconds: 30), () {
          print('TTS operation timed out');
          if (!_isDisposed) {
            isSpeaking.value = false;
            _completeActiveOperation();
          }
        });

        await flutterTts.speak(text);
      }
    } catch (e) {
      print('Error in TTS speak: $e');
      if (!_isDisposed) {
        isSpeaking.value = false;
        _completeActiveOperation();
      }
    }
  }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    if (_isDisposed) return;

    try {
      if (isSpeaking.value) {
        await flutterTts.stop();
        isSpeaking.value = false;

        // Wait for any active operation to complete with timeout
        if (_activeOperation != null && !_activeOperation!.isCompleted) {
          try {
            await _activeOperation!.future.timeout(
              Duration(milliseconds: 1000),
              onTimeout: () {
                print('TTS stop operation timed out');
                _completeActiveOperation();
              },
            );
          } catch (e) {
            print('Error waiting for TTS operation to complete: $e');
            _completeActiveOperation();
          }
        }
      }
    } catch (e) {
      print('Error stopping TTS: $e');
      // Force cleanup even if stop fails
      if (!_isDisposed) {
        isSpeaking.value = false;
        _completeActiveOperation();
      }
    }
  }

  /// Check if TTS is speaking for a specific screen
  bool isSpeakingForScreen(String screenName) {
    if (_isDisposed) return false;

    try {
      return isSpeaking.value && currentScreen.value == screenName;
    } catch (e) {
      print('Error checking speaking status: $e');
      return false;
    }
  }

  /// Clean shutdown method
  Future<void> dispose() async {
    if (_isDisposed) return;

    _isDisposed = true;
    try {
      // Cancel any timeout timer
      _timeoutTimer?.cancel();
      _timeoutTimer = null;

      // Stop any ongoing speech
      await flutterTts.stop();

      // Complete any pending operations
      _completeActiveOperation();

      // Reset state
      isSpeaking.value = false;
      currentScreen.value = '';

      print('TTS Service disposed successfully');
    } catch (e) {
      print('Error disposing TTS: $e');
    }
  }

  @override
  void onClose() {
    dispose();
    super.onClose();
  }
}
