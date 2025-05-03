import 'package:dyslexia_mate/core/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/services/tts_service/tts_dervice.dart';
import '../controllers/quiz_controller.dart';
import 'quiz_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Enable GetX test mode to allow contextless navigation without GetMaterialApp
    Get.testMode = true;

    // Set current screen for TTS
    TtsService.to.setCurrentScreen('StartScreen');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade300, Colors.blue.shade700],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Assets.assetsImagesLogo),
                  SizedBox(height: 24.h),
                  Text(
                    'اختبار مهارات القراءة',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.sp,
                        fontFamily: 'maqroo'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'هذا الاختبار يقيس مهارات القراءة الأساسية لدى الطفل ويساعد في تحديد مستوى خطر صعوبات القراءة',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: 'maqroo'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 48.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      final controller = Get.put(QuizController());
                      controller.startQuiz();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TestScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.play_arrow,
                      size: 24.sp,
                    ),
                    label: Text(
                      'ابدأ الاختبار',
                      style: TextStyle(fontSize: 18.sp, fontFamily: 'maqroo'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade700,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 16.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
