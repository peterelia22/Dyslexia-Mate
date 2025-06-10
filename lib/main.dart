import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'core/services/tts_service/tts_dervice.dart';
import 'features/profile/controllers/game_stats_controller.dart';
import 'features/profile/controllers/profile_controller.dart';
import 'features/speech_to_text/controllers/speech_to_text_controller.dart';
import 'firebase_options.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/utils/app_router.dart';
import 'core/utils/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(TtsService(), permanent: true);
  Get.put(SpeechController(), permanent: true);
  Get.lazyPut<UserProfileController>(() => UserProfileController());
  Get.lazyPut<GameStatsController>(() => GameStatsController());
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase Initialized Successfully!");
  } catch (e) {
    print("❌ Firebase Initialization Failed: $e");
  }

  runApp(
    ShowCaseWidget(
      builder: (context) => const DyslexiaMate(),
    ),
  );
}

class DyslexiaMate extends StatelessWidget {
  const DyslexiaMate({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // غيرها حسب التصميم الأساسي
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          initialRoute: AppRoutes.splash,
          routes: AppRouter.getRoutes(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
