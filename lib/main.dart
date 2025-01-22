import 'package:flutter/material.dart';

import 'common/layouts/main_layout.dart';
import 'common/screens/splash_screen.dart';
import 'core/utils/app_routes.dart';
import 'features/authentication/screens/login_screen.dart';
import 'features/authentication/screens/register_screen.dart';
import 'features/game/screens/game_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/speech_to_text/screens/speech_to_text_screen.dart';
import 'features/text_to_speech/screens/text_to_speech_screen.dart';

void main() {
  runApp(const DyslexiaMate());
}

class DyslexiaMate extends StatelessWidget {
  const DyslexiaMate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.onBoarding: (context) => const OnboardingScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.game: (context) => const MainLayout(child: GameScreen()),
        AppRoutes.home: (context) => const MainLayout(child: HomeScreen()),
        AppRoutes.speech_to_text: (context) =>
            const MainLayout(child: SpeechToTextScreen()),
        AppRoutes.text_to_speech: (context) =>
            const MainLayout(child: TextToSpeechScreen()),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
