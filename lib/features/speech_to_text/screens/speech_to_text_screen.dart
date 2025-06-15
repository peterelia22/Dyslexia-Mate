import 'package:dyslexia_mate/features/speech_to_text/controllers/speech_to_text_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SpeechToTextScreen extends StatelessWidget {
  SpeechToTextScreen({super.key});

  final SpeechController speechController = Get.find<SpeechController>();
  final GlobalKey _textKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: speechController.isListening.value ? 7 : 8,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF7AD1F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 20.h),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: speechController.scrollController,
                      child: Obx(() {
                        if (speechController.shouldShowTextField()) {
                          return Container(
                            padding: EdgeInsets.only(top: 20.h),
                            child: TextField(
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              controller:
                                  speechController.textEditingController,
                              style: TextStyle(
                                fontFamily: 'maqroo',
                                color: Colors.black,
                                fontSize: 50.sp,
                                fontWeight: FontWeight.w900,
                              ),
                              maxLines: null,
                              enabled: speechController.text.value !=
                                      speechController.defaultText &&
                                  speechController.text.value !=
                                      speechController.listeningText &&
                                  speechController.canEdit(),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: speechController.defaultText,
                              ),
                              onChanged: speechController.onTextChanged,
                              onTap: () {
                                if (speechController.canEdit()) {
                                  speechController.setEditing(true);
                                }
                              },
                              onEditingComplete: () {
                                speechController.setEditing(false);
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          );
                        }

                        if (speechController.isSpeaking.value &&
                            speechController.currentWordIndex.value >= 0) {
                          return GestureDetector(
                            onTap: () {
                              if (speechController.canEdit()) {
                                speechController.setEditing(true);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 20.h),
                              child: _buildHighlightedText(),
                            ),
                          );
                        }

                        return GestureDetector(
                          onTap: () {
                            if (speechController.canEdit()) {
                              speechController.setEditing(true);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 38.h),
                            child: Text(
                              speechController.text.value,
                              style: TextStyle(
                                fontFamily: 'maqroo',
                                color: Colors.black,
                                fontSize: 50.sp,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Obx(() {
                    if (speechController.shouldShowCopyIcon()) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Obx(() => IconButton(
                                    icon: Icon(
                                      speechController.isSpeaking.value
                                          ? Icons.volume_up
                                          : Icons.volume_up_outlined,
                                      color: speechController.isSpeaking.value
                                          ? Colors.blue
                                          : Colors.black,
                                      size: 24.sp,
                                    ),
                                    onPressed: speechController.speakText,
                                  )),
                              // Copy Icon
                              IconButton(
                                icon: Icon(Icons.copy,
                                    color: Colors.black, size: 24.sp),
                                onPressed: speechController.copyToClipboard,
                              ),
                            ],
                          ),
                          const SizedBox(),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Obx(() {
            if (speechController.shouldShowCopyIcon()) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'سرعة الصوت',
                      style: TextStyle(
                        fontFamily: 'maqroo',
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Slider(
                    value: speechController.speechRate.value,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    onChanged: (value) {
                      speechController.speechRate.value = value;
                    },
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
          SizedBox(height: 10.h),
          Expanded(
            flex: speechController.isListening.value ? 3 : 2,
            child: Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: speechController.isListening.value ? 120.w : 80.w,
                  height: speechController.isListening.value ? 120.h : 80.h,
                  decoration: BoxDecoration(
                    color: speechController.isListening.value
                        ? const Color(0xff0A1C3D)
                        : const Color(0xffCBA2EA),
                    shape: BoxShape.circle,
                    boxShadow: speechController.isListening.value
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              spreadRadius: 5.r,
                              blurRadius: 10.r,
                              offset: const Offset(0, 0),
                            )
                          ]
                        : null,
                  ),
                  child: IconButton(
                    icon: Icon(
                      speechController.isListening.value
                          ? Icons.mic
                          : Icons.mic_none,
                      size: 30.sp,
                      color: Colors.white,
                    ),
                    onPressed: speechController.listen,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText() {
    final text = speechController.text.value;
    final currentWordIndex = speechController.currentWordIndex.value;
    final textStyle = TextStyle(
      fontFamily: 'maqroo',
      color: Colors.black,
      fontSize: 50.sp,
      fontWeight: FontWeight.w900,
    );

    if (currentWordIndex < 0) {
      return Text(
        text,
        style: textStyle,
        textAlign: TextAlign.right,
        key: _textKey,
      );
    }

    final words = text
        .split(RegExp(r'(\s+|\b)'))
        .where((word) => word.trim().isNotEmpty)
        .toList();

    if (currentWordIndex >= words.length) {
      return Text(
        text,
        style: textStyle,
        textAlign: TextAlign.right,
        key: _textKey,
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Wrap(
        key: _textKey,
        alignment: WrapAlignment.end,
        children: List.generate(words.length, (index) {
          if (!speechController.wordKeys.containsKey(index)) {
            speechController.wordKeys[index] = GlobalKey();
          }

          final isHighlighted = index == currentWordIndex;

          if (isHighlighted) {
            return Container(
              key: speechController.wordKeys[index],
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: const Color(0xff266b96),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                words[index],
                style: textStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return Padding(
              key: speechController.wordKeys[index],
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text(
                words[index],
                style: textStyle,
              ),
            );
          }
        }),
      ),
    );
  }
}
