import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/tts_service/tts_dervice.dart';

/// Custom route observer to stop TTS when navigating between routes
class TtsRouteObserver extends NavigatorObserver {
  TtsService? get ttsService {
    try {
      return Get.find<TtsService>();
    } catch (e) {
      print('TTS Service not found: $e');
      return null;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // Stop TTS when navigating to a new route
    _stopTtsSafely();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // Stop TTS when navigating back
    _stopTtsSafely();
  }

  void _stopTtsSafely() {
    try {
      ttsService?.stopSpeaking();
    } catch (e) {
      print('Error stopping TTS in route observer: $e');
    }
  }
}
