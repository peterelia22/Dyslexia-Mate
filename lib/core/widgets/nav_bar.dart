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
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  Future<void> _playSound(String path, VoidCallback onComplete) async {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
    });

    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));

    _audioPlayer.onPlayerComplete.first.then((_) {
      setState(() {
        _isPlaying = false;
      });
      onComplete();
    });
  }

  void _startShowcase(
      GlobalKey key, String soundPath, VoidCallback onComplete) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([key]);

      _playSound(soundPath, () {
        ShowCaseWidget.of(context).dismiss();
        onComplete();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentIndex == 0) {
      _startShowcase(widget.homeKey, Assets.assetsSoundsHome, () {
        _startShowcase(widget.textToSpeechKey, Assets.assetsSoundsTextToSpeech,
            () {
          _startShowcase(
              widget.speechToTextKey, Assets.assetsSoundsSpeechToText, () {
            _startShowcase(widget.gameKey, Assets.assetsSoundsGame, () {});
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: _isPlaying,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
              color: Color(0xff05132C),
            ),
            child: BottomNavigationBar(
              currentIndex: widget.currentIndex,
              onTap: _isPlaying ? null : widget.onTap,
              backgroundColor: Colors.transparent,
              selectedItemColor: const Color(0xff91D2F4),
              unselectedItemColor: const Color(0xff297095),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Showcase(
                    key: widget.homeKey,
                    description: 'هنا يمكنك الذهاب للصفحة الرئيسية',
                    descTextStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    tooltipBackgroundColor: Colors.blueGrey.shade700,
                    disableBarrierInteraction: true,
                    disposeOnTap: false,
                    onTargetClick: () {
                      debugPrint("تم الضغط على الهدف");
                    },
                    child: const ImageIcon(AssetImage(Assets.assetsImagesHome)),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Showcase(
                    key: widget.textToSpeechKey,
                    description: 'تحويل النص إلى كلام',
                    descTextStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    tooltipBackgroundColor: Colors.blueGrey.shade700,
                    disableBarrierInteraction: true,
                    disposeOnTap: false,
                    onTargetClick: () {
                      debugPrint("تم الضغط على الهدف");
                    },
                    child: const Icon(Icons.text_fields),
                  ),
                  label: 'Text to Speech',
                ),
                BottomNavigationBarItem(
                  icon: Showcase(
                    key: widget.speechToTextKey,
                    description: 'تحويل الكلام إلى نص',
                    descTextStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    tooltipBackgroundColor: Colors.blueGrey.shade700,
                    disableBarrierInteraction: true,
                    disposeOnTap: false,
                    onTargetClick: () {
                      debugPrint("تم الضغط على الهدف");
                    },
                    child: const Icon(Icons.mic),
                  ),
                  label: 'Speech to Text',
                ),
                BottomNavigationBarItem(
                  icon: Showcase(
                    key: widget.gameKey,
                    description: 'يلا نلعب ونتعلم الحروف بطريقة سهلة ومسلية',
                    descTextStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    tooltipBackgroundColor: Colors.blueGrey.shade700,
                    disableBarrierInteraction: true,
                    disposeOnTap: false,
                    onTargetClick: () {
                      debugPrint("تم الضغط على الهدف");
                    },
                    child: const Icon(Icons.games),
                  ),
                  label: 'Game',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
