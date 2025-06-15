// ignore_for_file: prefer_single_quotes
import 'package:dyslexia_mate/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/user_model.dart';
import '../../../core/constants/assets.dart';

class UserProfilePage extends GetView<UserProfileController> {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.assetsImagesBackground),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  'الملف الشخصي',
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 18.sp),
                ),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: controller.refreshData,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: controller.refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserInfoCard(context),
                      SizedBox(height: 16.h),
                      _buildAccountInfoCard(),
                      SizedBox(height: 16.h),
                      _buildDyslexiaInfoCard(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Obx(() {
          if (controller.isLoadingUserData) {
            return SizedBox(
              height: 200.h,
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          final userData = controller.userData;
          if (userData == null) {
            return SizedBox(
              height: 100.h,
              child: const Center(
                child: Text(
                  "حدث خطأ في تحميل البيانات",
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: Colors.blue,
                child: Text(
                  userData.username?.isNotEmpty == true
                      ? userData.username![0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontSize: 36.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _buildUsernameSection(userData),
              SizedBox(height: 8.h),
              Text(
                userData.email ?? 'No Email',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                  fontFamily: 'Tajawal',
                ),
              ),
              SizedBox(height: 16.h),
              _buildFullNameSection(userData),
              SizedBox(height: 8.h),
              _buildDateOfBirthSection(context),
              if (controller.getAge() > 0) ...[
                SizedBox(height: 8.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Text(
                    'العمر: ${controller.getAge()} سنة',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDyslexiaInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.psychology, color: Colors.purple, size: 24.w),
                    SizedBox(width: 8.w),
                    Text(
                      'معلومات اختبار عسر القراءة',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _buildInfoRowWithIcon(
                  Icons.assignment_turned_in,
                  'حالة الاختبار',
                  controller.hasDyslexiaTest ? 'تم إجراؤه' : 'لم يتم إجراؤه',
                  valueColor:
                      controller.hasDyslexiaTest ? Colors.green : Colors.orange,
                ),
                if (controller.hasDyslexiaTest) ...[
                  _buildInfoRowWithIcon(
                    Icons.trending_up,
                    'مستوى المخاطر',
                    controller.getDyslexiaRiskLevelText(),
                    valueColor: controller.getDyslexiaRiskLevelColor(),
                  ),
                  _buildInfoRowWithIcon(
                    Icons.date_range,
                    'تاريخ الاختبار',
                    controller.getFormattedDyslexiaTestDate(),
                  ),
                ],
              ],
            )),
      ),
    );
  }

  Widget _buildAccountInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'معلومات الحساب',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            SizedBox(height: 12.h),
            _buildInfoRowWithIcon(
              Icons.date_range,
              'تاريخ إنشاء الحساب',
              controller.getAccountCreationDate(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameSection(UserModel userData) {
    return Obx(() {
      if (controller.isEditingUsername) {
        return SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.usernameController,
                  decoration: InputDecoration(
                    labelText: 'اسم المستخدم',
                    labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(fontFamily: 'Tajawal'),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                onPressed:
                    controller.isLoading ? null : controller.updateUsername,
                icon: controller.isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.check, color: Colors.green, size: 24.w),
              ),
              IconButton(
                onPressed: controller.toggleEditUsername,
                icon: Icon(Icons.close, color: Colors.red, size: 24.w),
              ),
            ],
          ),
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                userData.username ?? 'مجهول',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              onPressed: controller.toggleEditUsername,
              icon: Icon(Icons.edit, color: Colors.blue, size: 20.w),
            ),
          ],
        );
      }
    });
  }

  Widget _buildFullNameSection(UserModel userData) {
    return Obx(() {
      if (controller.isEditingFullName) {
        return SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.fullNameController,
                  decoration: InputDecoration(
                    labelText: 'الاسم الكامل',
                    labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(fontFamily: 'Tajawal'),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                onPressed:
                    controller.isLoading ? null : controller.updateFullName,
                icon: controller.isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.check, color: Colors.green, size: 24.w),
              ),
              IconButton(
                onPressed: controller.toggleEditFullName,
                icon: Icon(Icons.close, color: Colors.red, size: 24.w),
              ),
            ],
          ),
        );
      } else {
        return _buildInfoRow(
          'الاسم الكامل',
          userData.fullName ?? 'غير محدد',
          onEdit: controller.toggleEditFullName,
        );
      }
    });
  }

  Widget _buildDateOfBirthSection(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () => controller.selectDate(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'تاريخ الميلاد:',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.calendar_today, size: 16.w, color: Colors.blue),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        controller.getFormattedDate(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Tajawal',
                          color: controller.selectedDate != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.edit, color: Colors.blue, size: 16.w),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildInfoRow(String label, String value, {VoidCallback? onEdit}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onEdit != null) ...[
                  SizedBox(width: 8.w),
                  InkWell(
                    onTap: onEdit,
                    child: Icon(Icons.edit, color: Colors.blue, size: 16.w),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowWithIcon(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(icon, size: 20.w, color: Colors.grey[600]),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Tajawal',
                color: valueColor ?? Colors.black,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
