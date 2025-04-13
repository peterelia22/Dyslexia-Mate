import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:get/get.dart';

import '../../features/game/screens/game_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/speech_to_text/screens/speech_to_text_screen.dart';
import '../../features/speech_to_text/controllers/speech_to_text_controller.dart';
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
  int _previousIndex = 0;

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _textToSpeechKey = GlobalKey();
  final GlobalKey _speechToTextKey = GlobalKey();
  final GlobalKey _gameKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _previousIndex = _currentIndex;

    if (_currentIndex == 0) {
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

  void _handleTabChange(int index) {
    // Check if navigating away from speech-to-text screen (index 2)
    if (_currentIndex == 2 && index != 2) {
      // Reset speech controller when navigating away from speech-to-text screen
      if (Get.isRegistered<SpeechController>()) {
        final speechController = Get.find<SpeechController>();
        speechController.resetSpeechState();
      }
    }

    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
        onTap: _handleTabChange,
        homeKey: _homeKey,
        textToSpeechKey: _textToSpeechKey,
        speechToTextKey: _speechToTextKey,
        gameKey: _gameKey,
      ),
    );
  }
}
