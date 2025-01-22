import 'package:dyslexia_mate/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Text("مريم", style: TextStyles.usernameText),
                  SizedBox(height: 5),
                  Text("Sophie7@gmail.com", style: TextStyles.useremailText),
                ],
              ),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.solidUser),
              title: Text(
                "الملف الشخصي",
                style: TextStyles.draweritemText,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.share),
              title: const Text(
                "مشاركة التطبيق",
                style: TextStyles.draweritemText,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.solidStar),
              title: const Text(
                "اكتب رأيك",
                style: TextStyles.draweritemText,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.question),
              title: const Text(
                "الأسئلة الشائعة",
                style: TextStyles.draweritemText,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.sliders),
              title: const Text(
                "الإعدادات",
                style: TextStyles.draweritemText,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
