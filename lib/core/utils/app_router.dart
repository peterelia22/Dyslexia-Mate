import 'package:flutter/material.dart';
import '../../features/game/screens/game_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/speech_to_text/screens/speech_to_text_screen.dart';
import '../../features/text_to_speech/screens/text_to_speech_screen.dart';
import '../layouts/main_layout.dart';
import 'app_routes.dart';
import 'route_observer.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  // Create a route observer instance
  static final routeObserver = TtsRouteObserver();

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.home: (context) => const MainLayout(
            child: HomeScreen(),
            currentIndex: 0,
          ),
      AppRoutes.text_to_speech: (context) => const MainLayout(
            child: TextToSpeechScreen(),
            currentIndex: 1,
          ),
      AppRoutes.speech_to_text: (context) => MainLayout(
            child: SpeechToTextScreen(),
            currentIndex: 2,
          ),
      AppRoutes.game: (context) => const MainLayout(
            child: GameScreen(),
            currentIndex: 3,
          ),
    };
  }
}
