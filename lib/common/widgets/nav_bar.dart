import 'package:dyslexia_mate/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  final GlobalKey homeKey;
  final GlobalKey textToSpeechKey;
  final GlobalKey speechToTextKey;
  final GlobalKey gameKey;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.homeKey,
    required this.textToSpeechKey,
    required this.speechToTextKey,
    required this.gameKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
        color: Color(0xff05132C),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xff91D2F4),
        unselectedItemColor: const Color(0xff297095),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Showcase(
              key: homeKey,
              description: 'هنا يمكنك الذهاب للصفحة الرئيسية',
              descTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              tooltipBackgroundColor: Colors.blueGrey.shade700,
              child: const ImageIcon(AssetImage(Assets.assetsImagesHome)),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Showcase(
              key: textToSpeechKey,
              description: 'تحويل النص إلى كلام',
              descTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              tooltipBackgroundColor: Colors.blueGrey.shade700,
              child: const Icon(Icons.text_fields),
            ),
            label: 'Text to Speech',
          ),
          BottomNavigationBarItem(
            icon: Showcase(
              key: speechToTextKey,
              description: 'تحويل الكلام إلى نص',
              descTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              tooltipBackgroundColor: Colors.blueGrey.shade700,
              child: const Icon(Icons.mic),
            ),
            label: 'Speech to Text',
          ),
          BottomNavigationBarItem(
            icon: Showcase(
              key: gameKey,
              description: 'ابدأ اللعب هنا',
              descTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              tooltipBackgroundColor: Colors.blueGrey.shade700,
              child: const Icon(Icons.games),
            ),
            label: 'Game',
          ),
        ],
      ),
    );
  }
}
