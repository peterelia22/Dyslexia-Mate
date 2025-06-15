import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/assets.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  bool _isFormValid = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _subjectController.addListener(_validateForm);
    _bodyController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _subjectController.text.trim().isNotEmpty &&
          _bodyController.text.trim().isNotEmpty;
    });
  }

  Future<void> _sendFeedback() async {
    if (!_isFormValid || _isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('المستخدم غير مسجل الدخول');
      }

      final String senderEmail = currentUser.email ?? '';
      if (senderEmail.isEmpty) {
        throw Exception('لا يمكن العثور على بريد المستخدم الإلكتروني');
      }

      // Save to Firestore
      await FirebaseFirestore.instance.collection('feedback').add({
        'senderEmail': senderEmail,
        'subject': _subjectController.text.trim(),
        'message': _bodyController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'unread',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم إرسال التعليق بنجاح! ',
            style: TextStyle(
              fontFamily: 'Maqroo',
              fontSize: 16.sp,
            ),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
      _subjectController.clear();
      _bodyController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'فشل في إرسال التعليق: ${e.toString()}',
            style: TextStyle(
              fontFamily: 'Maqroo',
              fontSize: 16.sp,
            ),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.assetsImagesBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'التعليقات',
              style: TextStyle(
                fontFamily: 'Maqroo',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        'أرسل لنا تعليقاتك',
                        style: TextStyle(
                          fontFamily: 'Maqroo',
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Subject field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _subjectController,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Maqroo',
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          labelText: 'الموضوع',
                          hintText: 'أدخل موضوع التعليق',
                          labelStyle: TextStyle(
                            fontFamily: 'Maqroo',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                          hintStyle: TextStyle(
                            fontFamily: 'Maqroo',
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          prefixIcon:
                              Icon(Icons.subject, color: Colors.blue[700]),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 16.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Body field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _bodyController,
                        maxLines: 6,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontFamily: 'Maqroo',
                            fontSize: 22.5.sp,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: 'الرسالة',
                          hintText: 'أدخل رسالة التعليق',
                          labelStyle: TextStyle(
                            fontFamily: 'Maqroo',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                          hintStyle: TextStyle(
                            fontFamily: 'Maqroo',
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          prefixIcon:
                              Icon(Icons.message, color: Colors.blue[700]),
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 16.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Send button
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: _isFormValid && !_isSending
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ]
                            : [],
                      ),
                      child: ElevatedButton(
                        onPressed:
                            _isFormValid && !_isSending ? _sendFeedback : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid && !_isSending
                              ? Colors.blue
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: _isFormValid && !_isSending ? 5 : 2,
                        ),
                        child: _isSending
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'جاري الإرسال...',
                                    style: TextStyle(
                                      fontFamily: 'Maqroo',
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: _isFormValid ? 1.0 : 0.5,
                                child: Text(
                                  'إرسال التعليق',
                                  style: TextStyle(
                                    fontFamily: 'Maqroo',
                                    fontSize: 24.sp,
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
          ),
        ),
      ),
    );
  }
}
