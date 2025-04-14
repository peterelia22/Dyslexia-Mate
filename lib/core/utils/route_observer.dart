import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/tts_service/tts_dervice.dart';

/// Custom route observer to stop TTS when navigating between routes
class TtsRouteObserver extends NavigatorObserver {
  final TtsService ttsService = TtsService.to;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // Stop TTS when navigating to a new route
    ttsService.stopSpeaking();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // Stop TTS when navigating back
    ttsService.stopSpeaking();
  }
}
