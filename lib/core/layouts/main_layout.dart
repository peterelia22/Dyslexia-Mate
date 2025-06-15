import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../features/game/screens/game_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/speech_to_text/screens/speech_to_text_screen.dart';
import '../../features/text_to_speech/screens/text_to_speech_screen.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/nav_bar.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _textToSpeechKey = GlobalKey();
  final GlobalKey _speechToTextKey = GlobalKey();
  final GlobalKey _gameKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;

    // إصلاح: استخدام _currentIndex بدلاً من currentIndex
    if (_currentIndex == 0) {
      // إصلاح: إضافة parameter للـ Duration
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([
          _homeKey,
          _textToSpeechKey,
          _speechToTextKey,
          _gameKey,
        ]);
      });
    }
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const TextToSpeechScreen(),
    SpeechToTextScreen(),
    const GameScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      //  extendBody: true, // مهم عشان الـ body يمتد تحت الـ navbar
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        homeKey: _homeKey,
        textToSpeechKey: _textToSpeechKey,
        speechToTextKey: _speechToTextKey,
        gameKey: _gameKey,
      ),
    );
  }
}
