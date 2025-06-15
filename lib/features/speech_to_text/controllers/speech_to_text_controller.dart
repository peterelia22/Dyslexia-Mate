import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import 'dart:math' as math;

import '../../../core/services/tts_service/tts_dervice.dart';

class SpeechController extends GetxController {
  var speech = stt.SpeechToText();
  var isListening = false.obs;
  var text = ''.obs;
  Timer? timeoutTimer;

  final TtsService ttsService = TtsService.to;

  final String screenName = 'speech_to_text';

  var isSpeaking = false.obs;
  var speechRate = 0.5.obs;
  var currentWordIndex = RxInt(-1);
  var words = RxList<String>([]);
  var scrollPosition = RxDouble(0.0);

  final scrollController = ScrollController();
  final textEditingController = TextEditingController();
  var isEditing = false.obs;

  final Map<int, double> wordPositions = <int, double>{}.obs;
  final Map<int, GlobalKey> wordKeys = <int, GlobalKey>{}.obs;

  var isEditingEnabled = true.obs;

  final String defaultText = 'اضغط على الميكروفون وابدأ التحدث';
  final String listeningText = 'تكلم الآن ...';

  @override
  void onInit() {
    super.onInit();
    text.value = defaultText;
    textEditingController.text = defaultText;
    initSpeech();
    setupListeners();

    // Set the current screen when this controller is initialized
    ttsService.setCurrentScreen(screenName);

    // Sync the local isSpeaking with the TTS service
    ever(ttsService.isSpeaking, (bool speaking) {
      if (!speaking && isSpeaking.value) {
        isSpeaking.value = false;
        currentWordIndex.value = -1;
        isEditingEnabled.value = true;
      }
    });
  }

  void setupListeners() {
    // Listen for changes in text
    ever(text, (newText) {
      if (textEditingController.text != newText && !isEditing.value) {
        textEditingController.text = newText;
      }

      // Auto-scroll to the bottom when text changes (only if not editing)
      if (!isEditing.value && scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }

      // Clear word keys when text changes
      wordKeys.clear();
    });

    // Listen for changes in the current word index to scroll to the highlighted word
    ever(currentWordIndex, (index) {
      if (index >= 0 && scrollController.hasClients) {
        scrollToHighlightedWord();
      }
    });
  }

  void scrollToHighlightedWord() {
    if (currentWordIndex.value < 0 || !scrollController.hasClients) return;

    final wordIndex = currentWordIndex.value;
    final totalWords = words.length;

    if (wordIndex >= 0 && wordIndex < totalWords) {
      // Calculate scroll position with proactive approach
      final scrollExtent = scrollController.position.maxScrollExtent;
      final viewportHeight = scrollController.position.viewportDimension;
      final currentOffset = scrollController.offset;

      // Calculate relative position of the word in the text
      double relativePosition = wordIndex / totalWords;

      // Calculate target scroll position
      double targetScrollPosition = relativePosition * scrollExtent;

      // Check if the word is near the end of the visible area
      if (relativePosition > 0.9) {
        targetScrollPosition += viewportHeight * 0.3;
      }

      // If the word is in the last third of the text, scroll more proactively
      if (relativePosition > 0.7) {
        targetScrollPosition += viewportHeight * 0.2;
      }

      // Ensure scroll position is within bounds
      targetScrollPosition = math
          .max(
              0,
              math.min(targetScrollPosition,
                  scrollController.position.maxScrollExtent))
          .toDouble();

      // Only scroll if target position is significantly different from current position
      if (targetScrollPosition > currentOffset ||
          targetScrollPosition < currentOffset - viewportHeight * 0.5) {
        scrollController.animateTo(
          targetScrollPosition,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void initSpeech() async {
    bool available = await speech.initialize();
    if (!available) {
      text.value = 'التعرف على الكلام غير متاح';
    }
  }

  void listen() async {
    isEditing.value = false;
    if (!isListening.value) {
      bool available = await speech.initialize();
      if (available) {
        isListening.value = true;
        text.value = listeningText;

        speech.listen(
          onResult: (result) {
            if (result.recognizedWords.isNotEmpty) {
              text.value = result.recognizedWords;
              updateWordsList();
            }
            if (result.finalResult) {
              isListening.value = false;
              timeoutTimer?.cancel();
            }
          },
          localeId: "ar_SA",
          partialResults: true,
        );
      } else {
        text.value = 'التعرف على الكلام غير متاح';
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
    updateWordsList();
  }

  void copyToClipboard() {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text.value));
    }
  }

  Future<void> speakText() async {
    isEditing.value = false;
    if (shouldShowCopyIcon()) {
      if (isSpeaking.value) {
        await ttsService.stopSpeaking();
        isSpeaking.value = false;
        currentWordIndex.value = -1;
        isEditingEnabled.value = true;
      } else {
        updateWordsList();
        isSpeaking.value = true;
        isEditingEnabled.value = false;

        // Use the TTS service with progress handler for word highlighting
        await ttsService.speak(
          text: text.value,
          screenName: screenName,
          rate: speechRate.value,
          onProgress:
              (String text, int startOffset, int endOffset, String word) {
            int index = words.indexOf(word, currentWordIndex.value + 1);
            if (index != -1) {
              currentWordIndex.value = index;
            }
          },
          onComplete: () {
            isSpeaking.value = false;
            currentWordIndex.value = -1;
            isEditingEnabled.value = true;
          },
        );
      }
    }
  }

  bool shouldShowCopyIcon() {
    return text.value.isNotEmpty &&
        text.value != defaultText &&
        text.value != listeningText;
  }

  void updateWordsList() {
    if (text.value != defaultText && text.value != listeningText) {
      words.value = text.value
          .split(RegExp(r'[\s،،؛.؟!]+'))
          .where((word) => word.isNotEmpty)
          .toList();
    } else {
      words.clear();
    }
    currentWordIndex.value = -1;
  }

  void setEditing(bool value) {
    isEditing.value = value;
  }

  void onTextChanged(String value) {
    isEditing.value = true;
    text.value = value;
    updateWordsList();
  }

  bool canEdit() {
    return !isSpeaking.value && isEditingEnabled.value;
  }

  bool shouldShowTextField() {
    bool isDefaultOrListening =
        text.value == defaultText || text.value == listeningText;
    return isDefaultOrListening || (isEditing.value && canEdit());
  }

  @override
  void onClose() {
    // Stop TTS if this controller's screen is speaking
    if (ttsService.isSpeakingForScreen(screenName)) {
      ttsService.stopSpeaking();
    }
    textEditingController.dispose();
    scrollController.dispose();
    wordKeys.clear();
    super.onClose();
  }
}
