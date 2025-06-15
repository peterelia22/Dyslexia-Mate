import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/auth_service.dart';
import 'core/services/tts_service/tts_dervice.dart';
import 'core/services/quick_actions_service.dart';
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

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase Initialized Successfully!");
  } catch (e) {
    print("❌ Firebase Initialization Failed: $e");
  }

  // Initialize services in the correct order
  Get.put(TtsService(), permanent: true);
  Get.put(SpeechController(), permanent: true);
  Get.lazyPut(() => UserProfileController());
  Get.lazyPut(() => GameStatsController());

  // First initialize AuthService
  Get.put(AuthService(), permanent: true);

  // Then initialize QuickActionsService
  Get.put(QuickActionsService(), permanent: true);

  // Determine initial route based on pending quick actions
  String initialRoute = await _determineInitialRoute();

  runApp(
    ShowCaseWidget(
      builder: (context) => DyslexiaMate(initialRoute: initialRoute),
    ),
  );
}

Future<String> _determineInitialRoute() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final pendingAction = prefs.getString('pending_quick_action');

    if (pendingAction != null) {
      final authService = Get.find<AuthService>();

      // Check if user is logged in
      if (authService.isLoggedIn) {
        // User is logged in, go directly to the action
        switch (pendingAction) {
          case 'tts_action':
            // Clear the pending action
            await prefs.remove('pending_quick_action');
            return AppRoutes.text_to_speech;
          case 'stt_action':
            await prefs.remove('pending_quick_action');
            return AppRoutes.speech_to_text;
          case 'game_action':
            await prefs.remove('pending_quick_action');
            return AppRoutes.game;
        }
      } else {
        // User not logged in, save action in auth service and go to login
        authService.setPendingAction(pendingAction);
        await prefs.remove('pending_quick_action');
        return AppRoutes.login;
      }
    }
  } catch (e) {
    print('Error determining initial route: $e');
  }

  // Default to splash if no quick action
  return AppRoutes.splash;
}

class DyslexiaMate extends StatelessWidget {
  final String initialRoute;

  const DyslexiaMate({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialRoute: initialRoute,
          getPages: AppRouter.getPages(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
