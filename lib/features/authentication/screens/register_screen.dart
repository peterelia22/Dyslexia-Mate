import 'package:dyslexia_mate/core/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../constants/assets.dart';
import '../../../core/constants/text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Assets.assetsImagesBackground),
              fit: BoxFit.cover)),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 67,
                ),
                Center(
                  child: Text(
                    'إنشاء حساب',
                    style: TextStyle(
                      color: Color(0xFF3F3381),
                      fontSize: 32,
                      fontFamily: 'Maqroo',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                CustomTextField(icon: Icons.person, hintText: "الاسم الكامل"),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(icon: Icons.person, hintText: "اسم المستخدم"),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    icon: Icons.email, hintText: "البريد الإلكتروني"),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    isPassword: true,
                    icon: Icons.key_outlined,
                    hintText: "كلمة المرور"),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    isPassword: true,
                    icon: Icons.key_outlined,
                    hintText: "تأكيد كلمة المرور"),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: CustomButton(),
                ),
                Divider(
                  height: 40,
                  color: Color(0xff727272),
                  endIndent: 14,
                  indent: 14,
                ),
                Column(
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
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Row(
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
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text.rich(
                      TextSpan(
                        text: 'بتسجيلك، فإنك توافق على ',
                        style: TextStyles.linkText,
                        children: [
                          TextSpan(
                            text: 'الشروط والأحكام الخاصة بنا',
                            style: TextStyle(
                              color: Color(0xFFD8B7FF),
                              fontSize: 10,
                              fontFamily: 'Maqroo',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
