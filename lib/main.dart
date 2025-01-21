import 'package:dyslexia_mate/core/utils/app_routes.dart';
import 'package:dyslexia_mate/features/authentication/screens/register_screen.dart';
import 'package:flutter/material.dart';

import 'common/screens/splash_screen.dart';
import 'features/onboarding/Screens/onboarding_screen.dart';

void main() {
  runApp(const DyslexiaMate());
}

class DyslexiaMate extends StatelessWidget {
  const DyslexiaMate({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.onBoarding: (context) => const OnboardingScreen(),
        AppRoutes.register: (context) => const RegisterScreen()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
