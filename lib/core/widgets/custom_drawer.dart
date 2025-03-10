import 'package:dyslexia_mate/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue,
                child: Text("م", style: TextStyles.usernameText),
              ),
              SizedBox(height: 12),
              Text("مريم", style: TextStyles.usernameText),
              SizedBox(height: 6),
              Text("Sophie7@gmail.com", style: TextStyles.useremailText),
              SizedBox(
                height: 15,
              )
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.solidUser),
                  title: const Text(
                    "الملف الشخصي",
                    style: TextStyles.draweritemText,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.share),
                  title: const Text(
                    "مشاركة التطبيق",
                    style: TextStyles.draweritemText,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.solidStar),
                  title: const Text(
                    "اكتب رأيك",
                    style: TextStyles.draweritemText,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.question),
                  title: const Text(
                    "الأسئلة الشائعة",
                    style: TextStyles.draweritemText,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.sliders),
                  title: const Text(
                    "الإعدادات",
                    style: TextStyles.draweritemText,
                  ),
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
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
