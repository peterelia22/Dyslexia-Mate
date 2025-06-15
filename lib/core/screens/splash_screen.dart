import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/app_routes.dart';
import '../../core/services/quick_actions_service.dart';
import '../../core/services/auth_service.dart';
import '../constants/assets.dart';

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
    _initializeApp();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _opacity = 1;
        });
      }
    });
  }

  void _initializeApp() async {
    // Wait for minimum splash time and check for quick actions
    await Future.delayed(const Duration(seconds: 2));

    // Ensure services are initialized
    final quickActionsService = Get.find<QuickActionsService>();

    // Check for pending quick actions first
    await quickActionsService.checkForPendingActions();

    // If a quick action was handled, don't proceed with normal navigation
    // Wait a bit to see if navigation occurred
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if we're still on splash screen (no navigation happened from quick action)
    if (Get.currentRoute == AppRoutes.splash) {
      _checkUserStatus();
    }
  }

  void _checkUserStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, check dyslexia test status
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          bool hasDyslexiaTest = userData['hasDyslexiaTest'] ?? false;

          if (hasDyslexiaTest) {
            // User has completed dyslexia test, go to home
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else {
            // User hasn't completed dyslexia test, go to StartScreen
            Navigator.pushReplacementNamed(context, AppRoutes.startQuiz);
          }
        } else {
          // User document doesn't exist, go to StartScreen
          Navigator.pushReplacementNamed(context, AppRoutes.startQuiz);
        }
      } catch (e) {
        // Error fetching user data, go to StartScreen as fallback
        print('Error fetching user data: $e');
        Navigator.pushReplacementNamed(context, AppRoutes.startQuiz);
      }
    } else {
      // User is not logged in, go to onboarding
      Navigator.pushReplacementNamed(context, AppRoutes.onBoarding);
    }
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
