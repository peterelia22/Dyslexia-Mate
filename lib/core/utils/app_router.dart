import 'package:flutter/material.dart';
import '../../core/layouts/main_layout.dart';
import '../../core/screens/splash_screen.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/authentication/screens/register_screen.dart';
import '../../features/game/screens/game_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/speech_to_text/screens/speech_to_text_screen.dart';
import '../../features/text_to_speech/screens/text_to_speech_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.splash: (context) => const SplashScreen(),
      AppRoutes.onBoarding: (context) => const OnboardingScreen(),
      AppRoutes.register: (context) => RegisterScreen(),
      AppRoutes.login: (context) => LoginScreen(),
      AppRoutes.game: (context) =>
          const MainLayout(currentIndex: 3, child: GameScreen()),
      AppRoutes.home: (context) =>
          const MainLayout(currentIndex: 0, child: HomeScreen()),
      AppRoutes.speech_to_text: (context) =>
          const MainLayout(currentIndex: 2, child: SpeechToTextScreen()),
      AppRoutes.text_to_speech: (context) =>
          const MainLayout(currentIndex: 1, child: TextToSpeechScreen()),
    };
  }
}
