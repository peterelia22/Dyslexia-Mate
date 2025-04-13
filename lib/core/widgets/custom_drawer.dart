import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyslexia_mate/core/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dyslexia_mate/core/constants/text_styles.dart';

import '../../features/authentication/firebase_auth_service.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<Map<String, dynamic>?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 100),
          FutureBuilder<Map<String, dynamic>?>(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Loading Indicator
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return const Text("حدث خطأ في تحميل البيانات");
              }

              final userData = snapshot.data!;
              final String username = userData['username'] ?? 'مجهول';
              final String email = userData['email'] ?? 'No Email';
              final String firstLetter =
                  username.isNotEmpty ? username[0] : '?';

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                    child: Text(firstLetter, style: TextStyles.usernameText),
                  ),
                  const SizedBox(height: 12),
                  Text(username, style: TextStyles.usernameText),
                  const SizedBox(height: 6),
                  Text(email, style: TextStyles.useremailText),
                  const SizedBox(height: 15),
                ],
              );
            },
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.solidUser),
                  title: const Text("الملف الشخصي",
                      style: TextStyles.draweritemText),
                  onTap: () {},
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.share),
                  title: const Text("مشاركة التطبيق",
                      style: TextStyles.draweritemText),
                  onTap: () {},
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.solidStar),
                  title:
                      const Text("اكتب رأيك", style: TextStyles.draweritemText),
                  onTap: () {},
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.question),
                  title: const Text("الأسئلة الشائعة",
                      style: TextStyles.draweritemText),
                  onTap: () {},
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.sliders),
                  title:
                      const Text("الإعدادات", style: TextStyles.draweritemText),
                  onTap: () {},
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    "تسجيل الخروج",
                    style:
                        TextStyles.draweritemText.copyWith(color: Colors.red),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("تأكيد تسجيل الخروج"),
                        content:
                            const Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("إلغاء"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await FirebaseAuthService().signOut();
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.login);
                            },
                            child: const Text("تأكيد"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
