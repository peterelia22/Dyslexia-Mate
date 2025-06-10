import 'package:dyslexia_mate/core/screens/splash_screen.dart';
import 'package:dyslexia_mate/features/authentication/screens/login_screen.dart';
import 'package:dyslexia_mate/features/authentication/screens/register_screen.dart';
import 'package:dyslexia_mate/features/dyslexia_test/screens/start_screen.dart';
import 'package:dyslexia_mate/features/onboarding/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/feedback/views/feedback_screen.dart';
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

  // Keep your existing routes method for backward compatibility
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.feedBack: (context) => const FeedbackScreen(),
      AppRoutes.startQuiz: (context) => const StartScreen(),
      AppRoutes.login: (context) => LoginScreen(),
      AppRoutes.register: (context) => RegisterScreen(),
      AppRoutes.onBoarding: (context) => const OnboardingScreen(),
      AppRoutes.splash: (context) => const SplashScreen(),
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

  // New method to get GetX pages
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: AppRoutes.splash,
        page: () => const SplashScreen(),
      ),
      GetPage(
        name: AppRoutes.login,
        page: () => LoginScreen(),
      ),
      GetPage(
        name: AppRoutes.register,
        page: () => RegisterScreen(),
      ),
      GetPage(
        name: AppRoutes.onBoarding,
        page: () => const OnboardingScreen(),
      ),
      GetPage(
        name: AppRoutes.home,
        page: () => const MainLayout(
          child: HomeScreen(),
          currentIndex: 0,
        ),
      ),
      GetPage(
        name: AppRoutes.text_to_speech,
        page: () => const MainLayout(
          child: TextToSpeechScreen(),
          currentIndex: 1,
        ),
      ),
      GetPage(
        name: AppRoutes.speech_to_text,
        page: () => MainLayout(
          child: SpeechToTextScreen(),
          currentIndex: 2,
        ),
      ),
      GetPage(
        name: AppRoutes.game,
        page: () => const MainLayout(
          child: GameScreen(),
          currentIndex: 3,
        ),
      ),
      GetPage(
        name: AppRoutes.feedBack,
        page: () => const FeedbackScreen(),
      ),
      GetPage(
        name: AppRoutes.startQuiz,
        page: () => const StartScreen(),
      ),
    ];
  }
}
