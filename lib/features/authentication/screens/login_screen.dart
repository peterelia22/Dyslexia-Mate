import 'package:dyslexia_mate/constants/assets.dart';
import 'package:dyslexia_mate/core/constants/text_styles.dart';
import 'package:dyslexia_mate/core/utils/app_routes.dart';
import 'package:dyslexia_mate/features/authentication/widgets/custom_button.dart';
import 'package:dyslexia_mate/features/authentication/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../widgets/social_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Assets.assetsImagesBackground),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              const Center(
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyles.authHeadText,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const CustomTextField(
                  icon: Icons.email, hintText: "البريد الإلكتروني"),
              const SizedBox(
                height: 10,
              ),
              const CustomTextField(
                  isPassword: true,
                  icon: Icons.key_outlined,
                  hintText: "كلمة المرور"),
              const SizedBox(
                height: 14,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 13),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'هل نسيت كلمة المرور؟',
                    style: TextStyles.linkText,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.home);
                },
                child: const CustomButton(
                  text: 'تسجيل الدخول',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'أو المتابعة باستخدام',
                    style: TextStyles.linkText,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(
                    text: 'جوجل',
                    color: AppColors.buttonColor,
                    icon: Icons.g_mobiledata_sharp,
                  ),
                  SizedBox(width: 10),
                  SocialButton(
                    text: 'فيسبوك',
                    color: AppColors.buttonColor,
                    icon: Icons.facebook,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.register);
                },
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: 'ليس لديك حساب؟ ', style: TextStyles.linkText),
                      TextSpan(
                          text: 'أنشئ حساباً الآن',
                          style: TextStyles.linkText2),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
