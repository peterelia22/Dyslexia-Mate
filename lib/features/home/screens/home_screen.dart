import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/utils/app_routes.dart';
import '../../../core/constants/assets.dart';
import '../../../helpers/game_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Static variable to cache the username
  static String? _cachedUsername;
  String _searchQuery = '';

  Future<String> getUsername() async {
    // Return cached username if available
    if (_cachedUsername != null) {
      return _cachedUsername!;
    }

    // Fetch username from Firestore
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists && userDoc['username'] != null) {
        String fullName = userDoc['username'];
        _cachedUsername = fullName.split(" ").first; // Cache the first name
        return _cachedUsername!;
      }
    }
    _cachedUsername = "مستخدم"; // Cache default value if no username found
    return _cachedUsername!;
  }

  List<Map<String, dynamic>> get tasks => [
        {
          'image': Assets.assetsImagesCamera,
          'name': 'التقط صورًا للأشياء',
          'action': () => GameLauncher.launchObjectDetection(),
        },
        {
          'image': Assets.assetsImagesDraw,
          'name': 'ارسم الحروف',
          'action': () => GameLauncher.launchDrawLetters(),
        },
        {
          'image': Assets.assetsImagesDiscover,
          'name': 'ابحث عن الحروف المخفية',
          'action': () => GameLauncher.launchLetterHunt(),
        },
      ];

  List<Map<String, dynamic>> get recommended => [
        {
          'image': Assets.assetsImagesTextToSpeech,
          'name': 'اسمع ما مكتوب',
          'action': () =>
              Navigator.pushNamed(context, AppRoutes.text_to_speech),
        },
        {
          'image': Assets.assetsImagesSpeechToText,
          'name': 'اكتب ما تقول',
          'action': () =>
              Navigator.pushNamed(context, AppRoutes.speech_to_text),
        },
        {
          'image': Assets.assetsImagesDiscover,
          'name': 'اكتشف الحروف',
          'action': () => GameLauncher.launchGame(),
        }
      ];

  // Filter items based on search query
  List<Map<String, dynamic>> filterItems(List<Map<String, dynamic>> items) {
    if (_searchQuery.isEmpty) {
      return items;
    }
    return items.where((item) {
      return item['name']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = filterItems(tasks);
    final filteredRecommended = filterItems(recommended);

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
                      // Show cached username or placeholder while loading
                      return Text(
                        'أهلاً, ${_cachedUsername ?? "مستخدم"}',
                        style: TextStyles.usernameText,
                      );
                    } else if (snapshot.hasError) {
                      return Text('خطأ في تحميل البيانات',
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

              // Search Field with RTL text direction
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن النشاطات...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Text(
                  'مهام اليوم',
                  style: TextStyles.usernameText,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 300,
                child: filteredTasks.isEmpty && _searchQuery.isNotEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد نتائج للبحث',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredTasks.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GestureDetector(
                              onTap: task['action'],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Stack(
                                        children: [
                                          Image.asset(
                                            task['image']!,
                                            width: 206,
                                            height: 220,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: const Center(
                                                child: Text(
                                                  'انقر للعب',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
                child: filteredRecommended.isEmpty && _searchQuery.isNotEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد نتائج للبحث',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredRecommended.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final recommend = filteredRecommended[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GestureDetector(
                              onTap: recommend['action'],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Stack(
                                        children: [
                                          Image.asset(
                                            recommend['image']!,
                                            width: 206,
                                            height: 220,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: const Center(
                                                child: Text(
                                                  'انقر للفتح',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
