import 'package:dyslexia_mate/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/user_model.dart';

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
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'الملف الشخصي',
                style: TextStyle(fontFamily: 'maqroo', fontSize: 18.sp),
              ),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  onPressed: controller.refreshData,
                  icon: const Icon(Icons.refresh),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'logout') {
                      _showLogoutDialog(context);
                    } else if (value == 'settings') {
                      // Navigate to settings
                      // Get.toNamed('/settings');
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'settings',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.settings, size: 20.w),
                          SizedBox(width: 8.w),
                          Text('الإعدادات',
                              style: TextStyle(fontFamily: 'maqroo')),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.logout, size: 20.w, color: Colors.red),
                          SizedBox(width: 8.w),
                          Text('تسجيل الخروج',
                              style: TextStyle(
                                  fontFamily: 'maqroo', color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
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
                    _buildQuickActionsCard(context),
                    SizedBox(height: 20.h), // Extra space at bottom
                  ],
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
              child: Center(
                child: Text(
                  "حدث خطأ في تحميل البيانات",
                  style: TextStyle(fontFamily: 'maqroo'),
                ),
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar and basic info
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
                    fontFamily: 'maqroo',
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Username section
              _buildUsernameSection(userData),
              SizedBox(height: 8.h),

              // Email
              Text(
                userData.email ?? 'No Email',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                  fontFamily: 'maqroo',
                ),
              ),
              SizedBox(height: 16.h),

              // Full name section
              _buildFullNameSection(userData),
              SizedBox(height: 8.h),

              // Date of birth section
              _buildDateOfBirthSection(context),

              // Age display
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
                      fontFamily: 'maqroo',
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

  Widget _buildUsernameSection(UserModel userData) {
    return Obx(() {
      if (controller.isEditingUsername) {
        return Container(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.usernameController,
                  decoration: InputDecoration(
                    labelText: 'اسم المستخدم',
                    labelStyle: TextStyle(fontFamily: 'maqroo'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                  style: TextStyle(fontFamily: 'maqroo'),
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
                        child: CircularProgressIndicator(strokeWidth: 2),
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
                  fontFamily: 'maqroo',
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
        return Container(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.fullNameController,
                  decoration: InputDecoration(
                    labelText: 'الاسم الكامل',
                    labelStyle: TextStyle(fontFamily: 'maqroo'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                  style: TextStyle(fontFamily: 'maqroo'),
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
                        child: CircularProgressIndicator(strokeWidth: 2),
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
          onTap: () => _showDatePickerOptions(context),
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
                        fontFamily: 'maqroo',
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
                          fontFamily: 'maqroo',
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

  void _showDatePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اختر طريقة تحديد التاريخ',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'maqroo',
                  ),
                ),
                SizedBox(height: 20.h),
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.blue),
                  title: Text(
                    'منتقي التاريخ العادي',
                    style: TextStyle(fontFamily: 'maqroo'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    controller.selectDateAlternative(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.tune, color: Colors.green),
                  title: Text(
                    'منتقي التاريخ المخصص',
                    style: TextStyle(fontFamily: 'maqroo'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    controller.showCustomDatePicker(context);
                  },
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAccountInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
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
                fontFamily: 'maqroo',
              ),
            ),
            SizedBox(height: 12.h),
            _buildInfoRowWithIcon(
              Icons.date_range,
              'تاريخ إنشاء الحساب',
              controller.getAccountCreationDate(),
            ),
            _buildInfoRowWithIcon(
              Icons.verified_user,
              'حالة التحقق',
              controller.getEmailVerificationStatus(),
              valueColor:
                  controller.isEmailVerified() ? Colors.green : Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'إجراءات سريعة',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'maqroo',
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.sports_esports,
                    label: 'إحصائيات الألعاب',
                    color: Colors.green,
                    onTap: () {
                      // Navigate to game stats
                      // Get.toNamed('/game-stats');
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.settings,
                    label: 'الإعدادات',
                    color: Colors.blue,
                    onTap: () {
                      // Navigate to settings
                      // Get.toNamed('/settings');
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.help,
                    label: 'المساعدة',
                    color: Colors.orange,
                    onTap: () {
                      // Navigate to help
                      // Get.toNamed('/help');
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.logout,
                    label: 'تسجيل الخروج',
                    color: Colors.red,
                    onTap: () => _showLogoutDialog(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24.w),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'maqroo',
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
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
              fontFamily: 'maqroo',
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
                      fontFamily: 'maqroo',
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
                fontFamily: 'maqroo',
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'maqroo',
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              'تسجيل الخروج',
              style: TextStyle(fontFamily: 'maqroo'),
            ),
            content: Text(
              'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
              style: TextStyle(fontFamily: 'maqroo'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'إلغاء',
                  style: TextStyle(fontFamily: 'maqroo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.signOut();
                },
                child: Text(
                  'تسجيل الخروج',
                  style: TextStyle(fontFamily: 'maqroo', color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
