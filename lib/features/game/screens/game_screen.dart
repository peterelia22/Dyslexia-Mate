import 'package:flutter/material.dart';
import 'package:dyslexia_mate/helpers/game_launcher.dart';

import '../../../core/constants/assets.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.assetsImagesGameScreen),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'الحروف \n المفقودة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w700,
                  height: 1.03,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: GameLauncher.launchGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E2D55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(205, 50),
              ),
              child: const Text(
                'ابدأ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  height: 1.33,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
