import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSource(this.firebaseAuth, this.googleSignIn);

  // دالة لتسجيل الدخول باستخدام قوقل
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    // الحصول على بيانات توثيق قوقل واستخدامها لتسجيل الدخول
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

//إجراء تسجيل الدخول في فاير بيز وإرجاع المستخدم
    return (await firebaseAuth.signInWithCredential(credential)).user;
  }

// دالة لتسجيل الخروج
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }

  // Stream لمراقبة حالة المستخدم الحالي
  Stream<User?> get currentUser => firebaseAuth.authStateChanges();

  //    تحديث اسم المستخدم في مصداقية فاير بيز
  //Firebase Authentication
  Future<void> updateUserName(String userId, String userName) async {
    await firebaseAuth.currentUser?.updateDisplayName(userName);
  }
}
