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
        DocumentReference userDoc = _firestore.collection('users').doc(uid);

        transaction.set(userDoc, {
          'fullName': fullName,
          'email': email,
          'dateOfBirth': dateOfBirth,
          'username': username,
        });

        DocumentReference scoreDoc = userDoc.collection('score').doc('games');
        transaction.set(scoreDoc, {
          'game1': 0,
          'game2': 0,
          'game3': 0,
        });
      });
    } catch (e) {
      throw e;
    }
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
