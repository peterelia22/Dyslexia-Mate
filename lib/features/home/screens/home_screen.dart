import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia_mate/core/constants/text_styles.dart';
import 'package:dyslexia_mate/core/utils/app_routes.dart';
import '../../../core/constants/assets.dart';
import '../widgets/custom_search_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<String> getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists && userDoc['username'] != null) {
        String fullName = userDoc['username'];
        return fullName.split(" ").first; // جلب الاسم الأول فقط
      }
    }
    return "مستخدم"; // في حالة لم يتم العثور على الاسم
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tasks = [
      {
        'image': Assets.assetsImagesCamera,
        'name': '"التقط صورًا لثلاثة أشياء تبدأ بالحرف "ب'
      },
      {'image': Assets.assetsImagesDraw, 'name': '"ارسم حرف ال"م"'},
    ];
    final List<Map<String, String>> recommended = [
      {'image': Assets.assetsImagesTextToSpeech, 'name': 'اسمع ما مكتوب'},
      {'image': Assets.assetsImagesSpeechToText, 'name': 'اكتب ما تقول'},
      {'image': Assets.assetsImagesDiscover, 'name': 'اكتشف الحروف'}
    ];

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 150),
              Center(
                child: FutureBuilder<String>(
                  future: getUsername(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('خطأ في تحميل البيانات',
                          style: TextStyles.usernameText);
                    }
                    return Text('أهلاً, ${snapshot.data}',
                        style: TextStyles.usernameText);
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  '!مرحباً بعودتك ',
                  style: TextStyle(
                    color: Color(0xFF3D3F49),
                    fontSize: 16,
                    fontFamily: 'Maqroo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Center(child: CustomSearchField()),
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.only(right: 30),
                child: Text(
                  'مهام اليوم',
                  style: TextStyles.usernameText,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tasks.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                task['image']!,
                                width: 206,
                                height: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                task['name']!,
                                style: TextStyles.usernameText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(right: 30),
                child: Text(
                  'موصّى به من أجلك',
                  style: TextStyles.usernameText,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommended.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final recommend = recommended[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          if (recommend['name'] == 'اسمع ما مكتوب') {
                            Navigator.pushNamed(
                                context, AppRoutes.text_to_speech);
                          } else if (recommend['name'] == 'اكتب ما تقول') {
                            Navigator.pushNamed(
                                context, AppRoutes.speech_to_text);
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  recommend['image']!,
                                  width: 206,
                                  height: 220,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  recommend['name']!,
                                  style: TextStyles.usernameText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
