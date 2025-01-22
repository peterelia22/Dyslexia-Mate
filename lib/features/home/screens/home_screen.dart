import 'package:dyslexia_mate/constants/assets.dart';
import 'package:dyslexia_mate/core/constants/text_styles.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_search_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsImagesBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                ),
                Center(
                  child: Text('أهلاً, مريم', style: TextStyles.usernameText),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '!مرحباً بعودتك ',
                  style: TextStyle(
                    color: Color(0xFF3D3F49),
                    fontSize: 16,
                    fontFamily: 'Maqroo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                CustomSearchField()
              ],
            ),
          ),
        ));
  }
}
