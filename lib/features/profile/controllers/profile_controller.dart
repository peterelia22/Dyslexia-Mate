import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../../core/widgets/custom_snackBar.dart';
import '../models/user_model.dart';

class UserProfileController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  // Observable variables
  final _userData = Rxn<UserModel>();
  final _isEditingUsername = false.obs;
  final _isEditingFullName = false.obs;
  final _isLoading = false.obs;
  final _isLoadingUserData = false.obs;
  final _selectedDate = Rxn<DateTime>();

  // Dyslexia test information
  final _dyslexiaRiskLevel = RxnString();
  final _hasDyslexiaTest = false.obs;
  final _dyslexiaTestDate = RxnString();

  // Getters
  UserModel? get userData => _userData.value;
  bool get isEditingUsername => _isEditingUsername.value;
  bool get isEditingFullName => _isEditingFullName.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingUserData => _isLoadingUserData.value;
  DateTime? get selectedDate => _selectedDate.value;
  String? get dyslexiaRiskLevel => _dyslexiaRiskLevel.value;
  bool get hasDyslexiaTest => _hasDyslexiaTest.value;
  String? get dyslexiaTestDate => _dyslexiaTestDate.value;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  @override
  void onClose() {
    usernameController.dispose();
    fullNameController.dispose();
    super.onClose();
  }

  Future<void> refreshData() async {
    await getUserData();
  }

  Future<void> getUserData() async {
    try {
      _isLoadingUserData.value = true;

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get user basic data
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          _userData.value = UserModel.fromMap(userData);
          usernameController.text = _userData.value?.username ?? '';
          fullNameController.text = _userData.value?.fullName ?? '';

          // Set dyslexia test information
          _hasDyslexiaTest.value = userData['hasDyslexiaTest'] ?? false;
          _dyslexiaRiskLevel.value = userData['dyslexiaRiskLevel'];
          _dyslexiaTestDate.value = userData['dyslexiaTestDate'];

          // Parse date of birth
          if (_userData.value?.dateOfBirth != null &&
              _userData.value!.dateOfBirth!.isNotEmpty &&
              _userData.value!.dateOfBirth != 'غير محدد') {
            try {
              _selectedDate.value =
                  DateTime.parse(_userData.value!.dateOfBirth!);
            } catch (e) {
              _selectedDate.value = null;
            }
          }
        }
      }
    } catch (e) {
      _showSnackbar('خطأ', 'فشل في تحميل بيانات المستخدم: ${e.toString()}',
          ContentType.failure);
    } finally {
      _isLoadingUserData.value = false;
    }
  }

  String getDyslexiaRiskLevelText() {
    if (!_hasDyslexiaTest.value) return 'لم يتم إجراء الاختبار';

    // Return the Arabic text directly from Firestore
    return _dyslexiaRiskLevel.value ?? 'غير محدد';
  }

  Color getDyslexiaRiskLevelColor() {
    if (!_hasDyslexiaTest.value) return Colors.grey;

    // Check Arabic risk level text
    switch (_dyslexiaRiskLevel.value) {
      case 'خطر منخفض':
        return Colors.green;
      case 'خطر متوسط':
        return Colors.orange;
      case 'خطر مرتفع':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getFormattedDyslexiaTestDate() {
    if (_dyslexiaTestDate.value == null || _dyslexiaTestDate.value!.isEmpty) {
      return 'غير محدد';
    }

    try {
      DateTime date = DateTime.parse(_dyslexiaTestDate.value!);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'غير محدد';
    }
  }

  void toggleEditUsername() {
    _isEditingUsername.value = !_isEditingUsername.value;
    if (!_isEditingUsername.value) {
      usernameController.text = userData?.username ?? '';
    }
  }

  void toggleEditFullName() {
    _isEditingFullName.value = !_isEditingFullName.value;
    if (!_isEditingFullName.value) {
      fullNameController.text = userData?.fullName ?? '';
    }
  }

  Future<void> selectDate(BuildContext context) async {
    try {
      final DateTime? picked = await showDialog<DateTime>(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: DatePickerDialog(
                initialDate: _selectedDate.value ?? DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                helpText: 'اختر تاريخ الميلاد',
                cancelText: 'إلغاء',
                confirmText: 'موافق',
                fieldLabelText: 'تاريخ الميلاد',
                fieldHintText: 'يوم/شهر/سنة',
                errorFormatText: 'تنسيق التاريخ غير صحيح',
                errorInvalidText: 'التاريخ غير صالح',
                initialCalendarMode: DatePickerMode.day,
              ),
            ),
          );
        },
      );

      if (picked != null && picked != _selectedDate.value) {
        _selectedDate.value = picked;
        await updateDateOfBirth();
      }
    } catch (e) {
      _showSnackbar('خطأ', 'حدث خطأ في اختيار التاريخ: ${e.toString()}',
          ContentType.failure);
    }
  }

  Future<void> updateUsername() async {
    if (usernameController.text.trim().isEmpty) {
      _showSnackbar('خطأ', 'يرجى إدخال اسم مستخدم صحيح', ContentType.warning);
      return;
    }

    try {
      _isLoading.value = true;

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'username': usernameController.text.trim()});

        _userData.value = UserModel(
          username: usernameController.text.trim(),
          email: userData?.email,
          fullName: userData?.fullName,
          dateOfBirth: userData?.dateOfBirth,
        );

        _showSnackbar(
            'نجح', 'تم تحديث اسم المستخدم بنجاح', ContentType.success);
        _isEditingUsername.value = false;
      }
    } catch (e) {
      _showSnackbar('خطأ', 'حدث خطأ: ${e.toString()}', ContentType.failure);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateFullName() async {
    if (fullNameController.text.trim().isEmpty) {
      _showSnackbar('خطأ', 'يرجى إدخال الاسم الكامل', ContentType.warning);
      return;
    }

    try {
      _isLoading.value = true;

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'fullName': fullNameController.text.trim()});

        _userData.value = UserModel(
          username: userData?.username,
          email: userData?.email,
          fullName: fullNameController.text.trim(),
          dateOfBirth: userData?.dateOfBirth,
        );

        _showSnackbar(
            'نجح', 'تم تحديث الاسم الكامل بنجاح', ContentType.success);
        _isEditingFullName.value = false;
      }
    } catch (e) {
      _showSnackbar('خطأ', 'حدث خطأ: ${e.toString()}', ContentType.failure);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateDateOfBirth() async {
    if (_selectedDate.value == null) return;

    try {
      _isLoading.value = true;

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String dateString =
            _selectedDate.value!.toIso8601String().split('T')[0];

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'dateOfBirth': dateString});

        _userData.value = UserModel(
          username: userData?.username,
          email: userData?.email,
          fullName: userData?.fullName,
          dateOfBirth: dateString,
        );

        _showSnackbar(
            'نجح', 'تم تحديث تاريخ الميلاد بنجاح', ContentType.success);
      }
    } catch (e) {
      _showSnackbar('خطأ', 'حدث خطأ: ${e.toString()}', ContentType.failure);
    } finally {
      _isLoading.value = false;
    }
  }

  String getFormattedDate() {
    if (_selectedDate.value == null) return 'غير محدد';

    return '${_selectedDate.value!.day}/${_selectedDate.value!.month}/${_selectedDate.value!.year}';
  }

  int getAge() {
    if (_selectedDate.value == null) return 0;

    DateTime now = DateTime.now();
    int age = now.year - _selectedDate.value!.year;

    if (now.month < _selectedDate.value!.month ||
        (now.month == _selectedDate.value!.month &&
            now.day < _selectedDate.value!.day)) {
      age--;
    }

    return age;
  }

  String getAccountCreationDate() {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user?.metadata.creationTime != null) {
        DateTime creationDate = user!.metadata.creationTime!;
        return '${creationDate.day}/${creationDate.month}/${creationDate.year}';
      }
    } catch (e) {
      // Handle error silently
    }
    return 'غير محدد';
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Get.offAllNamed('/login'); // Navigate to login page
    } catch (e) {
      _showSnackbar('خطأ', 'حدث خطأ أثناء تسجيل الخروج: ${e.toString()}',
          ContentType.failure);
    }
  }

  void _showSnackbar(String title, String message, ContentType contentType) {
    try {
      if (Get.context != null) {
        CustomSnackbar.show(
          Get.context!,
          title: title,
          message: message,
          contentType: contentType,
        );
      }
    } catch (e) {
      print('Error showing snackbar: $e');
    }
  }
}
