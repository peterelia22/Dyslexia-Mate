import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/speech_to_text_controller.dart';

class SpeechToTextScreen extends StatelessWidget {
  const SpeechToTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SpeechController speechController = Get.put(SpeechController());
    final ScrollController scrollController = ScrollController();
    final TextEditingController textEditingController = TextEditingController();
    textEditingController.text = speechController.text.value;

    ever(speechController.text, (newText) {
      if (textEditingController.text != newText) {
        textEditingController.text = newText;
      }
    });

    ever(speechController.text, (_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
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
                  SizedBox(height: 75.h),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Obx(() {
                        bool isEditable = speechController.text.value !=
                                speechController.defaultText &&
                            speechController.text.value !=
                                speechController.listeningText;

                        return TextField(
                          controller: textEditingController,
                          onChanged: (value) {
                            speechController.text.value = value;
                          },
                          style: TextStyle(
                            fontFamily: 'maqroo',
                            color: Colors.black,
                            fontSize: 50.sp,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: null,
                          enabled: isEditable,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: speechController.defaultText,
                          ),
                        );
                      }),
                    ),
                  ),
                  Obx(() {
                    if (speechController.shouldShowCopyIcon()) {
                      return Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                          icon: Icon(Icons.copy,
                              color: Colors.black, size: 24.sp),
                          onPressed: speechController.copyToClipboard,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Obx(() => AnimatedContainer(
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
                            spreadRadius: 10.r,
                            blurRadius: 20.r,
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
                    size: 40.sp,
                    color: Colors.white,
                  ),
                  onPressed: speechController.listen,
                ),
              )),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
