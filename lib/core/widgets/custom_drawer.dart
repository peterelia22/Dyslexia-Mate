import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyslexia_mate/core/constants/assets.dart';
import 'package:dyslexia_mate/core/utils/app_routes.dart';
import 'package:dyslexia_mate/features/profile/views/game_stats_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dyslexia_mate/core/constants/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/authentication/firebase_auth_service.dart';
import '../../features/profile/views/profile_sccreen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // Static cache للبيانات
  static Map<String, dynamic>? _cachedUserData;
  static String? _cachedUserId;
  static bool _isDataLoaded = false;

  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // التحقق من وجود البيانات في الكاش للمستخدم الحالي
        if (_isDataLoaded &&
            _cachedUserId == user.uid &&
            _cachedUserData != null) {
          // استخدام البيانات المحفوظة
          if (mounted) {
            setState(() {
              userData = _cachedUserData;
              isLoading = false;
              hasError = false;
            });
          }
          return;
        }

        // تحميل البيانات من Firestore فقط إذا لم تكن محفوظة
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (mounted && userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>?;

          // حفظ البيانات في الكاش
          _cachedUserData = data;
          _cachedUserId = user.uid;
          _isDataLoaded = true;

          setState(() {
            userData = data;
            isLoading = false;
            hasError = false;
          });
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
              hasError = true;
            });
          }
        }
      } else {
        // مسح الكاش إذا لم يكن هناك مستخدم
        _clearCache();
        if (mounted) {
          setState(() {
            isLoading = false;
            hasError = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    }
  }

  // دالة لمسح الكاش (مفيدة عند تسجيل الخروج)
  static void _clearCache() {
    _cachedUserData = null;
    _cachedUserId = null;
    _isDataLoaded = false;
  }

  // دالة لتحديث البيانات يدوياً (يمكن استدعاؤها من ProfilePage مثلاً)
  static void refreshUserData() {
    _clearCache();
  }

  // Dialog مخصص للأطفال المصابين بعسر القراءة
  void _showFriendlyLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        elevation: 10,
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade50,
                Colors.purple.shade50,
              ],
            ),
            border: Border.all(
              color: Colors.blue.shade200,
              width: 2.w,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // أيقونة ودودة
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange.shade300,
                    width: 3.w,
                  ),
                ),
                child: Icon(
                  Icons.waving_hand,
                  size: 40.sp,
                  color: Colors.orange.shade600,
                ),
              ),

              SizedBox(height: 20.h),

              // العنوان بخط كبير وواضح
              Text(
                "هل تريد الخروج؟",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                  fontFamily: 'maqroo',
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.h),

              // النص التوضيحي بلغة بسيطة
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: Colors.blue.shade200,
                    width: 1.w,
                  ),
                ),
                child: Text(
                  "😊 ! سنفتقدك \nيمكنك العودة في أي وقت",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: Colors.grey.shade700,
                    height: 1.5,
                    fontFamily: 'maqroo',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 24.h),

              // الأزرار بتصميم ودود
              Row(
                children: [
                  // زر البقاء
                  Expanded(
                    child: Container(
                      height: 60.h,
                      margin: EdgeInsets.only(right: 8.w),
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.favorite,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                        label: Text(
                          "أريد البقاء",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'maqroo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade400,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          elevation: 5,
                          shadowColor: Colors.green.shade200,
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 12.h),
                        ),
                      ),
                    ),
                  ),

                  // زر الخروج
                  Expanded(
                    child: Container(
                      height: 60.h,
                      margin: EdgeInsets.only(left: 8.w),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          // مسح الكاش قبل تسجيل الخروج
                          _clearCache();
                          await FirebaseAuthService().signOut();
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.login);
                        },
                        icon: Icon(
                          Icons.exit_to_app,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                        label: Text(
                          "نعم، الخروج",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'maqroo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade400,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          elevation: 5,
                          shadowColor: Colors.orange.shade200,
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 12.h),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    if (isLoading) {
      return const CircularProgressIndicator(
        color: Colors.white,
      );
    }

    if (hasError || userData == null) {
      return Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 40.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            "حدث خطأ في تحميل البيانات",
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          TextButton(
            onPressed: () {
              // مسح الكاش وإعادة المحاولة
              _clearCache();
              setState(() {
                isLoading = true;
                hasError = false;
              });
              _loadUserData();
            },
            child: Text(
              "إعادة المحاولة",
              style: TextStyle(
                color: Colors.blue.shade200,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    final String username = userData!['username'] ?? 'مجهول';
    final String email = userData!['email'] ?? 'No Email';
    final String firstLetter = username.isNotEmpty ? username[0] : '?';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40.r,
          backgroundColor: Colors.white,
          child: Text(
            firstLetter,
            style: TextStyles.usernameText.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          username,
          style: TextStyles.usernameText.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            shadows: [
              Shadow(
                offset: const Offset(1, 1),
                blurRadius: 3,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          email,
          style: TextStyles.useremailText.copyWith(
            color: Colors.white70,
            fontSize: 14.sp,
            shadows: [
              Shadow(
                offset: const Offset(1, 1),
                blurRadius: 3,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsImagesLightDrawer),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // إضافة overlay شفاف للتأكد من وضوح النص
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 100.h),
              _buildUserInfo(),
              Divider(color: Colors.white.withOpacity(0.3)),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.solidUser,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      title: Text(
                        "الملف الشخصي",
                        style: TextStyles.draweritemText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context); // إغلاق الدرج أولاً
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserProfilePage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.share,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      title: Text(
                        "مشاركة التطبيق",
                        style: TextStyles.draweritemText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.solidStar,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      title: Text(
                        "اكتب رأيك",
                        style: TextStyles.draweritemText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.feedBack);
                      },
                    ),
                    ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.question,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      title: Text(
                        "الأسئلة الشائعة",
                        style: TextStyles.draweritemText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context); // إغلاق الدرج أولاً
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GameStatsPage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.sliders,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      title: Text(
                        "الإعدادات",
                        style: TextStyles.draweritemText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      onTap: () {},
                    ),
                    Divider(color: Colors.white.withOpacity(0.3)),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 20.sp,
                      ),
                      title: Text(
                        "تسجيل الخروج",
                        style: TextStyles.draweritemText.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      onTap: () => _showFriendlyLogoutDialog(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
