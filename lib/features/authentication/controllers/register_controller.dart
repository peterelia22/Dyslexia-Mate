import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_routes.dart';
import '../../../core/widgets/custom_snackBar.dart';
import '../firebase_auth_service.dart';

class RegisterController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  void signUp(BuildContext context) async {
    _isLoading.value = true;

    String fullName = fullNameController.text.trim();
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String dateOfBirth = dateOfBirthController.text.trim();

    if (fullName.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        dateOfBirth.isEmpty) {
      CustomSnackbar.show(
        context,
        title: "خطأ",
        message: "يرجى ملء جميع الحقول",
        contentType: ContentType.failure,
      );
      _isLoading.value = false;
      return;
    }

    if (password != confirmPassword) {
      CustomSnackbar.show(
        context,
        title: "خطأ",
        message: "كلمتا المرور غير متطابقتين",
        contentType: ContentType.failure,
      );
      _isLoading.value = false;
      return;
    }

    try {
      var result = await _authService.signUp(
          email, password, fullName, dateOfBirth, username);

      if (result['success']) {
        CustomSnackbar.show(
          context,
          title: "نجاح",
          message: "!تم إنشاء الحساب بنجاح",
          contentType: ContentType.success,
        );
        _navigateToHome(context);
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
        message: "حدث خطأ أثناء التسجيل: ${e.toString()}",
        contentType: ContentType.failure,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void signInWithGoogle(BuildContext context) async {
    _isLoading.value = true;

    try {
      var result = await _authService.signInWithGoogle();

      if (result['success']) {
        String message = result['isNewUser']
            ? "تم إنشاء حساب جديد بنجاح باستخدام Google!"
            : "تم تسجيل الدخول بنجاح باستخدام Google!";

        CustomSnackbar.show(
          context,
          title: "نجاح",
          message: message,
          contentType: ContentType.success,
        );

        _navigateToHome(context);
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
        message: "حدث خطأ أثناء تسجيل الدخول باستخدام Google: ${e.toString()}",
        contentType: ContentType.failure,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void _navigateToHome(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.pushReplacementNamed(context, AppRoutes.startQuiz);
  }
}
