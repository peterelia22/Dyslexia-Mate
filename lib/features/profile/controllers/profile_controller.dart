import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

  // Getters
  UserModel? get userData => _userData.value;
  bool get isEditingUsername => _isEditingUsername.value;
  bool get isEditingFullName => _isEditingFullName.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingUserData => _isLoadingUserData.value;
  DateTime? get selectedDate => _selectedDate.value;

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
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          _userData.value =
              UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
          usernameController.text = _userData.value?.username ?? '';
          fullNameController.text = _userData.value?.fullName ?? '';

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
              colorScheme: ColorScheme.light(
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

  // Alternative method using showDatePicker with proper localization
  Future<void> selectDateAlternative(BuildContext context) async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
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
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr, // Keep LTR for date picker
              child: child!,
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

  // Custom date picker using bottom sheet
  Future<void> showCustomDatePicker(BuildContext context) async {
    DateTime tempDate = _selectedDate.value ?? DateTime(2000);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'اختر تاريخ الميلاد',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'maqroo',
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Row(
                    children: [
                      // Day picker
                      Expanded(
                        child: Column(
                          children: [
                            Text('اليوم',
                                style: TextStyle(fontFamily: 'maqroo')),
                            Expanded(
                              child: ListWheelScrollView.useDelegate(
                                itemExtent: 50,
                                onSelectedItemChanged: (index) {
                                  tempDate = DateTime(
                                      tempDate.year, tempDate.month, index + 1);
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  builder: (context, index) {
                                    if (index < 0 || index >= 31) return null;
                                    return Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                            fontSize: 16, fontFamily: 'maqroo'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Month picker
                      Expanded(
                        child: Column(
                          children: [
                            Text('الشهر',
                                style: TextStyle(fontFamily: 'maqroo')),
                            Expanded(
                              child: ListWheelScrollView.useDelegate(
                                itemExtent: 50,
                                onSelectedItemChanged: (index) {
                                  tempDate = DateTime(
                                      tempDate.year, index + 1, tempDate.day);
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  builder: (context, index) {
                                    if (index < 0 || index >= 12) return null;
                                    List<String> months = [
                                      'يناير',
                                      'فبراير',
                                      'مارس',
                                      'أبريل',
                                      'مايو',
                                      'يونيو',
                                      'يوليو',
                                      'أغسطس',
                                      'سبتمبر',
                                      'أكتوبر',
                                      'نوفمبر',
                                      'ديسمبر'
                                    ];
                                    return Center(
                                      child: Text(
                                        months[index],
                                        style: TextStyle(
                                            fontSize: 16, fontFamily: 'maqroo'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Year picker
                      Expanded(
                        child: Column(
                          children: [
                            Text('السنة',
                                style: TextStyle(fontFamily: 'maqroo')),
                            Expanded(
                              child: ListWheelScrollView.useDelegate(
                                itemExtent: 50,
                                onSelectedItemChanged: (index) {
                                  tempDate = DateTime(1950 + index,
                                      tempDate.month, tempDate.day);
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  builder: (context, index) {
                                    int year = 1950 + index;
                                    if (year > DateTime.now().year) return null;
                                    return Center(
                                      child: Text(
                                        '$year',
                                        style: TextStyle(
                                            fontSize: 16, fontFamily: 'maqroo'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                              fontFamily: 'maqroo', color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _selectedDate.value = tempDate;
                          updateDateOfBirth();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(
                          'موافق',
                          style: TextStyle(
                              fontFamily: 'maqroo', color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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

  String getEmailVerificationStatus() {
    try {
      return FirebaseAuth.instance.currentUser?.emailVerified == true
          ? 'تم التحقق'
          : 'لم يتم التحقق';
    } catch (e) {
      return 'غير محدد';
    }
  }

  bool isEmailVerified() {
    try {
      return FirebaseAuth.instance.currentUser?.emailVerified == true;
    } catch (e) {
      return false;
    }
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
      // Fallback: print error if snackbar fails
      print('Error showing snackbar: $e');
    }
  }
}
