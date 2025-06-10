import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>> signUp(String email, String password,
      String fullName, String dateOfBirth, String username) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _createUserDocument(
            credential.user!.uid, fullName, email, dateOfBirth, username);
        return {'success': true, 'user': credential.user};
      }
      return {'success': false, 'error': 'فشل في إنشاء الحساب'};
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = '.كلمة المرور ضعيفة. يرجى اختيار كلمة مرور أقوى';
          break;
        case 'email-already-in-use':
          errorMessage =
              '.البريد الإلكتروني مستخدم بالفعل. يرجى استخدام بريد إلكتروني آخر';
          break;
        case 'invalid-email':
          errorMessage =
              '.البريد الإلكتروني غير صالح. يرجى إدخال بريد إلكتروني صحيح';
          break;
        default:
          errorMessage = '.حدث خطأ أثناء التسجيل. يرجى المحاولة مرة أخرى';
      }
      return {'success': false, 'error': errorMessage};
    }
  }

  Future<void> _createUserDocument(String uid, String fullName, String email,
      String dateOfBirth, String username) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // إنشاء document المستخدم
        DocumentReference userDoc = _firestore.collection('users').doc(uid);
        transaction.set(userDoc, {
          'fullName': fullName,
          'username': username,
          'email': email,
          'dateOfBirth': dateOfBirth,
          'hasDyslexiaTest': false, // لم يقم بالاختبار بعد
          'dyslexiaRiskLevel': null,
          'dyslexiaTestDate': null,
        });

        // إنشاء draw_letter document بـ rounds فاضي
        DocumentReference drawLetterDoc =
            userDoc.collection('game_data').doc('draw_letter');
        transaction.set(drawLetterDoc, {
          'correctScore': 0,
          'incorrectScore': 0,
          'rounds': [], // فاضي - سيتم إضافة rounds عند اللعب فقط
        });

        // إنشاء letter_hunt document بـ rounds فاضي
        DocumentReference letterHuntDoc =
            userDoc.collection('game_data').doc('letter_hunt');
        transaction.set(letterHuntDoc, {
          'correctScore': 0,
          'incorrectScore': 0,
          'rounds': [], // فاضي - سيتم إضافة rounds عند اللعب فقط
        });

        // إنشاء object_detection document بـ rounds فاضي
        DocumentReference objectDetectionDoc =
            userDoc.collection('game_data').doc('object_detection');
        transaction.set(objectDetectionDoc, {
          'correctScore': 0,
          'incorrectScore': 0,
          'rounds': [], // فاضي - سيتم إضافة rounds عند اللعب فقط
        });

        // إنشاء player_data document
        DocumentReference playerDataDoc =
            userDoc.collection('game_data').doc('player_data');
        transaction.set(playerDataDoc, {
          'energyPoints': 0,
          'lastTimeEnergyIncreasedUTC': "",
          'unlockedSkillNames': [],
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  // دالة لحفظ نتائج اختبار عسر القراءة في subcollection منفصل
  Future<void> saveDyslexiaTestResults(
      String uid, Map<String, dynamic> testData) async {
    try {
      DocumentReference userDoc = _firestore.collection('users').doc(uid);

      // إنشاء dyslexia_test subcollection مع document للنتائج
      DocumentReference dyslexiaTestDoc =
          userDoc.collection('dyslexia_test').doc('test_result');

      await _firestore.runTransaction((transaction) async {
        // حفظ نتائج الاختبار في subcollection منفصل
        transaction.set(dyslexiaTestDoc, testData);

        // تحديث وثيقة المستخدم الرئيسية
        transaction.update(userDoc, {
          'hasDyslexiaTest': true,
          'dyslexiaRiskLevel': testData['riskLevel'],
          'dyslexiaTestDate': testData['testDate'],
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  // دالة للتحقق من وجود اختبار عسر القراءة
  Future<bool> hasDyslexiaTest(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return data['hasDyslexiaTest'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // دالة لجلب نتائج اختبار عسر القراءة من subcollection
  Future<Map<String, dynamic>?> getDyslexiaTestResults(String uid) async {
    try {
      DocumentSnapshot dyslexiaDoc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('dyslexia_test')
          .doc('test_result')
          .get();

      if (dyslexiaDoc.exists) {
        return dyslexiaDoc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // دالة لحذف نتائج اختبار عسر القراءة (في حالة الحاجة لإعادة الاختبار)
  Future<void> deleteDyslexiaTestResults(String uid) async {
    try {
      DocumentReference userDoc = _firestore.collection('users').doc(uid);
      DocumentReference dyslexiaTestDoc =
          userDoc.collection('dyslexia_test').doc('test_result');

      await _firestore.runTransaction((transaction) async {
        // حذف نتائج الاختبار
        transaction.delete(dyslexiaTestDoc);

        // تحديث وثيقة المستخدم الرئيسية
        transaction.update(userDoc, {
          'hasDyslexiaTest': false,
          'dyslexiaRiskLevel': null,
          'dyslexiaTestDate': null,
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  // دالة لإضافة round جديدة لأي لعبة
  Future<void> addGameRound(
      String uid, String gameType, Map<String, dynamic> roundData) async {
    try {
      DocumentReference gameDoc = _firestore
          .collection('users')
          .doc(uid)
          .collection('game_data')
          .doc(gameType);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(gameDoc);

        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          List<dynamic> rounds = List.from(data['rounds'] ?? []);
          rounds.add(roundData);

          transaction.update(gameDoc, {
            'rounds': rounds,
          });
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  // دالة لتحديث النقاط
  Future<void> updateGameScore(
      String uid, String gameType, int correctScore, int incorrectScore) async {
    try {
      DocumentReference gameDoc = _firestore
          .collection('users')
          .doc(uid)
          .collection('game_data')
          .doc(gameType);

      await gameDoc.update({
        'correctScore': FieldValue.increment(correctScore),
        'incorrectScore': FieldValue.increment(incorrectScore),
      });
    } catch (e) {
      rethrow;
    }
  }

  // مثال لإضافة round للعبة draw_letter
  // هيكل الـ round: {isCorrect: bool, targetLetter: String, timestampCairoTime: String}
  Future<void> addDrawLetterRound(
    String uid, {
    required bool isCorrect,
    required String targetLetter,
    required String timestampCairoTime,
  }) async {
    Map<String, dynamic> roundData = {
      'isCorrect': isCorrect,
      'targetLetter': targetLetter,
      'timestampCairoTime': timestampCairoTime,
    };

    await addGameRound(uid, 'draw_letter', roundData);
  }

  // مثال لإضافة round للعبة letter_hunt
  // هيكل الـ round: {chosenWordCorrectFormate: String, isCorrect: bool, targetLetter: String, timestampCairoTime: String}
  Future<void> addLetterHuntRound(
    String uid, {
    required String chosenWordCorrectFormate,
    required bool isCorrect,
    required String targetLetter,
    required String timestampCairoTime,
  }) async {
    Map<String, dynamic> roundData = {
      'chosenWordCorrectFormate': chosenWordCorrectFormate,
      'isCorrect': isCorrect,
      'targetLetter': targetLetter,
      'timestampCairoTime': timestampCairoTime,
    };

    await addGameRound(uid, 'letter_hunt', roundData);
  }

  // مثال لإضافة round للعبة object_detection
  // هيكل الـ round: {isCorrect: bool, targetLetter: String, timestampCairoTime: String}
  Future<void> addObjectDetectionRound(
    String uid, {
    required bool isCorrect,
    required String targetLetter,
    required String timestampCairoTime,
  }) async {
    Map<String, dynamic> roundData = {
      'isCorrect': isCorrect,
      'targetLetter': targetLetter,
      'timestampCairoTime': timestampCairoTime,
    };

    await addGameRound(uid, 'object_detection', roundData);
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'success': true, 'user': credential.user};
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = '.لم يتم العثور على حساب بهذا البريد الإلكتروني.';
          break;
        case 'wrong-password':
          errorMessage = '.كلمة المرور غير صحيحة';
          break;
        case 'invalid-email':
          errorMessage = '.البريد الإلكتروني غير صالح';
          break;
        case 'user-disabled':
          errorMessage = '.تم تعطيل هذا الحساب. يرجى الاتصال بالدعم';
          break;
        case 'too-many-requests':
          errorMessage = '.تم إجراء الكثير من المحاولات. يرجى المحاولة لاحقًا';
          break;
        case 'invalid-credential':
          errorMessage = '.يرجى التحقق من البريد الإلكتروني وكلمة المرور';
          break;
        default:
          errorMessage = '.حدث خطأ أثناء تسجيل الدخول: ${e.code}';
      }
      return {'success': false, 'error': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'error': 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.'
      };
    }
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {
          'success': false,
          'error': 'تم إلغاء تسجيل الدخول بواسطة Google'
        };
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        bool isNewUser = !userDoc.exists;

        if (isNewUser) {
          await _createUserDocument(
            user.uid,
            user.displayName ?? '',
            user.email ?? '',
            '',
            user.email?.split('@')[0] ?? '',
          );
        }

        return {
          'success': true,
          'user': user,
          'isNewUser': isNewUser,
        };
      } else {
        return {
          'success': false,
          'error': 'فشل في تسجيل الدخول باستخدام Google'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'حدث خطأ أثناء تسجيل الدخول باستخدام Google'
      };
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
