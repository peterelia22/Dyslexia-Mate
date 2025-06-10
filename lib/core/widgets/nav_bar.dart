import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:audioplayers/audioplayers.dart';

import '../constants/assets.dart';

class CustomBottomNavigationBar extends StatefulWidget {
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
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBar();
}

class _CustomBottomNavigationBar extends State<CustomBottomNavigationBar> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int _currentShowcaseIndex = 0;
  final List<GlobalKey> _showcaseKeys = [];
  final List<String> _showcaseSounds = [];

  @override
  void initState() {
    super.initState();
    _setupShowcaseSequence();

    if (widget.currentIndex == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startNextShowcase();
      });
    }
  }

  void _setupShowcaseSequence() {
    // Set up the sequence of showcases and their corresponding sounds
    _showcaseKeys.addAll([
      widget.homeKey,
      widget.textToSpeechKey,
      widget.speechToTextKey,
      widget.gameKey
    ]);

    _showcaseSounds.addAll([
      Assets.assetsSoundsHome,
      Assets.assetsSoundsTextToSpeech,
      Assets.assetsSoundsSpeechToText,
      Assets.assetsSoundsGame
    ]);
  }

  Future<void> _playSound(String path) async {
    try {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = true;
      });

      await _audioPlayer.play(AssetSource(path));

      _audioPlayer.onPlayerComplete.first.then((_) {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } catch (e) {
      debugPrint('Error playing sound: $e');
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _startNextShowcase() {
    if (_currentShowcaseIndex < _showcaseKeys.length) {
      // Start the current showcase
      ShowCaseWidget.of(context)
          .startShowCase([_showcaseKeys[_currentShowcaseIndex]]);

      _playSound(_showcaseSounds[_currentShowcaseIndex]);
    }
  }

  void _skipCurrentShowcase() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });

    ShowCaseWidget.of(context).dismiss();

    _currentShowcaseIndex++;

    await Future.delayed(const Duration(milliseconds: 300));

    if (_currentShowcaseIndex < _showcaseKeys.length) {
      _startNextShowcase();
    } else {
      await _stopAllAudioAndFinish();
    }
  }

  Future<void> _stopAllAudioAndFinish() async {
    await _audioPlayer.stop();

    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }

    debugPrint('All showcases completed and audio stopped');
  }

  void _handleShowcaseAction() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });

    // اقفل الـ showcase الحالية
    ShowCaseWidget.of(context).dismiss();

    // تحقق إذا كان هذا آخر showcase
    bool isLastShowcase = _currentShowcaseIndex >= _showcaseKeys.length - 1;

    if (isLastShowcase) {
      // لو آخر showcase، اوقف كل حاجة
      await _stopAllAudioAndFinish();
    } else {
      // لو مش آخر showcase، انتقل للتالي
      _currentShowcaseIndex++;
      await Future.delayed(const Duration(milliseconds: 300));
      _startNextShowcase();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff05132C), // شفافية مع لون خفيف
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onTap,
        backgroundColor: Colors.transparent, // شفافة تماماً
        elevation: 0, // إزالة الظل
        selectedItemColor: const Color(0xff91D2F4),
        unselectedItemColor: const Color(0xff297095),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Showcase(
              key: widget.homeKey,
              description: 'هنا يمكنك الذهاب للصفحة الرئيسية',
              descTextStyle: const TextStyle(
                fontFamily: 'maqroo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              tooltipBackgroundColor: Colors.blueGrey.shade700,
              onBarrierClick: _handleShowcaseAction,
              disposeOnTap: false,
              onTargetClick: _handleShowcaseAction,
              child: const ImageIcon(AssetImage(Assets.assetsImagesHome)),
            ),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Showcase(
              key: widget.textToSpeechKey,
              description: 'تحويل النص إلى كلام',
              descTextStyle: const TextStyle(
                fontFamily: 'maqroo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              tooltipBackgroundColor: Colors.blueGrey.shade700,
              onBarrierClick: _handleShowcaseAction,
              disposeOnTap: false,
              onTargetClick: _handleShowcaseAction,
              child: const Icon(Icons.text_fields),
            ),
            label: 'اقرأ لي',
          ),
          BottomNavigationBarItem(
            icon: Showcase(
              key: widget.speechToTextKey,
              description: 'تحويل الكلام إلى نص',
              descTextStyle: const TextStyle(
                fontFamily: 'maqroo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              tooltipBackgroundColor: Colors.blueGrey.shade700,
              onBarrierClick: _handleShowcaseAction,
              disposeOnTap: false,
              onTargetClick: _handleShowcaseAction,
              child: const Icon(Icons.mic),
            ),
            label: 'سجل صوتك',
          ),
          BottomNavigationBarItem(
            icon: Showcase(
              key: widget.gameKey,
              description: 'يلا نلعب ونتعلم الحروف بطريقة سهلة ومسلية',
              descTextStyle: const TextStyle(
                fontFamily: 'maqroo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              tooltipBackgroundColor: Colors.blueGrey.shade700,
              disableBarrierInteraction: false,
              disposeOnTap: false,
              onTargetClick: _handleShowcaseAction,
              onBarrierClick: _handleShowcaseAction,
              child: const Icon(Icons.games),
            ),
            label: 'الألعاب',
          ),
        ],
      ),
    );
  }
}
