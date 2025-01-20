import 'package:dyslexia_mate/constants/assets.dart';
import 'package:flutter/material.dart';

class OnboardingCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final bool isLastPage;

  const OnboardingCard({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.isLastPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          color: const Color(0xFF101C29),
        ),

        Positioned(
          top: -screenHeight * 0.15,
          left: -screenWidth * 0.2,
          child: Image.asset(
            Assets.assetsImagesEllipse,
            width: screenWidth * 1.4,
          ),
        ),

        // Main content
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  width: screenWidth * 0.7,
                ),
                const SizedBox(height: 30),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Maqroo",
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Maqroo",
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
