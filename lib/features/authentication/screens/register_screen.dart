import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dyslexia_mate/core/constants/colors.dart';
import 'package:dyslexia_mate/core/constants/assets.dart';
import 'package:dyslexia_mate/core/constants/text_styles.dart';
import '../controllers/register_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_button.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController _controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.assetsImagesBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 67),
                const Text(
                  'إنشاء حساب',
                  style: TextStyles.authHeadText,
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 50),
                CustomTextField(
                  icon: Icons.person,
                  hintText: "الاسم الكامل",
                  controller: _controller.fullNameController,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  icon: Icons.person,
                  hintText: "اسم المستخدم",
                  controller: _controller.usernameController,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  icon: Icons.email,
                  hintText: "البريد الإلكتروني",
                  controller: _controller.emailController,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  icon: Icons.calendar_today,
                  hintText: "تاريخ الميلاد",
                  isDate: true,
                  controller: _controller.dateOfBirthController,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  isPassword: true,
                  icon: Icons.key_outlined,
                  hintText: "كلمة المرور",
                  controller: _controller.passwordController,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  isPassword: true,
                  icon: Icons.key_outlined,
                  hintText: "تأكيد كلمة المرور",
                  controller: _controller.confirmPasswordController,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Obx(() => _controller.isLoading
                      ? const CircularProgressIndicator()
                      : CustomElevatedButton(
                          onPressed: () => _controller.signUp(context),
                          text: 'سجّل الآن',
                        )),
                ),
                const Divider(
                  height: 40,
                  color: Color(0xff727272),
                  endIndent: 14,
                  indent: 14,
                ),
                const Column(
                  textDirection: TextDirection.rtl,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        'أو المتابعة باستخدام',
                        style: TextStyles.linkText,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialButton(
                      onPressed: () => _controller.signInWithGoogle(context),
                      text: 'جوجل',
                      color: AppColors.buttonColor,
                      icon: const Icon(
                        Icons.g_mobiledata,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    //  SocialButton(
                    //      onPressed: null,
                    //      text: 'فيسبوك',
                    //     color: AppColors.buttonColor,
                    //   icon: Icons.facebook,
                    //  ),
                  ],
                ),
                const SizedBox(height: 20),
                //    const Align(
                //    alignment: Alignment.centerLeft,
                //    child: Padding(
                //      padding: EdgeInsets.only(left: 12),
                //      child: Text.rich(
                //       TextSpan(
                //     text: 'بتسجيلك، فإنك توافق على ',
                //    style: TextStyles.linkText,
                //   children: [
                //      TextSpan(
                //        text: 'الشروط والأحكام الخاصة بنا',
                //        style: TextStyles.linkText2,
                //      ),
                //    ],
                //    ),
                //   textAlign: TextAlign.left,
                //     textDirection: TextDirection.ltr,
                //    ),
                //  ),
                //  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
