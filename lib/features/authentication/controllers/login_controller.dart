import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/utils/app_routes.dart';
import '../../../core/widgets/custom_snackBar.dart';
import '../firebase_auth_service.dart';

class LoginController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;

  void signIn(BuildContext context) async {
    isLoading.value = true;

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      CustomSnackbar.show(
        context,
        title: "خطأ",
        message: "يرجى إدخال البريد الإلكتروني وكلمة المرور",
        contentType: ContentType.failure,
      );
      isLoading.value = false;
      return;
    }

    try {
      var result = await _authService.signIn(email, password);

      if (result['success']) {
        CustomSnackbar.show(
          context,
          title: "نجاح",
          message: "!تم تسجيل الدخول بنجاح",
          contentType: ContentType.success,
        );

        // التحقق من حالة اختبار عسر القراءة
        await _checkDyslexiaTestAndNavigate(context, result['user']);
      } else {
        CustomSnackbar.show(
          context,
          title: "خطأ",
          message: result['error'],
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        title: "خطأ غير متوقع",
        message: "حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.",
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithGoogle(BuildContext context) async {
    isGoogleLoading.value = true;

    try {
      var result = await _authService.signInWithGoogle();

      if (result['success']) {
        CustomSnackbar.show(
          context,
          title: "نجاح",
          message: "تم تسجيل الدخول بنجاح باستخدام Google!",
          contentType: ContentType.success,
        );

        // التحقق من حالة اختبار عسر القراءة
        await _checkDyslexiaTestAndNavigate(context, result['user']);
      } else {
        CustomSnackbar.show(
          context,
          title: "خطأ",
          message: result['error'],
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        title: "خطأ غير متوقع",
        message: "حدث خطأ أثناء تسجيل الدخول باستخدام Google.",
        contentType: ContentType.failure,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

  // دالة للتحقق من حالة اختبار عسر القراءة وتوجيه المستخدم
  Future<void> _checkDyslexiaTestAndNavigate(
      BuildContext context, User user) async {
    try {
      // التحقق من وجود اختبار عسر القراءة
      bool hasDyslexiaTest = await _authService.hasDyslexiaTest(user.uid);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (hasDyslexiaTest) {
        // إذا كان المستخدم قد أجرى الاختبار، انتقل للصفحة الرئيسية
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        // إذا لم يجر المستخدم الاختبار، انتقل لصفحة بداية الاختبار
        Navigator.pushReplacementNamed(context, AppRoutes.startQuiz);
      }
    } catch (e) {
      // في حالة حدوث خطأ، انتقل للصفحة الرئيسية كخيار افتراضي
      print('Error checking dyslexia test status: $e');
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  void onClose() {
    //  emailController.dispose();
    //  passwordController.dispose();
    super.onClose();
  }
}
