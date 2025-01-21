import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dyslexia_mate/constants/assets.dart';
import 'package:dyslexia_mate/core/constants/colors.dart';
import 'package:dyslexia_mate/features/onboarding/onboarding_card.dart';

import '../../core/utils/app_routes.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    _navigateToOnboardingScreen();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _opacity = 1;
      });
    });
  }

  void _navigateToOnboardingScreen() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.onBoarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.assetsImagesLogo),
              const SizedBox(height: 20),
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 1),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Dyslexia\n",
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 60,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: "Mate",
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 60,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
