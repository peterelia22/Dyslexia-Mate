// onboarding/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/utils/app_routes.dart';
import '../data/onboarding_data.dart';
import '../widgets/onboarding_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: onboardingPages.length,
            itemBuilder: (context, index) {
              return OnboardingCard(
                image: onboardingPages[index].image,
                title: onboardingPages[index].title,
                subtitle: onboardingPages[index].subtitle,
              );
            },
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: _currentPage != onboardingPages.length - 1
                ? TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(onboardingPages.length - 1);
                    },
                    child: const Text(
                      "تخطي",
                      style:
                          TextStyle(fontFamily: "Maqroo", color: Colors.white),
                    ),
                  )
                : const SizedBox(),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: SizedBox(
              width: 40,
              height: 40,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  if (_currentPage == onboardingPages.length - 1) {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: Color(0xff7265e2),
                  size: 14,
                ),
              ),
            ),
          ),
          Container(
            alignment: const Alignment(0, 0.94),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: onboardingPages.length,
              effect: const JumpingDotEffect(
                activeDotColor: Colors.white,
                dotColor: Colors.white54,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
