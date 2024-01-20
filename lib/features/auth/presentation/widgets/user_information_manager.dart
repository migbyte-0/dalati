import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//مدير معلومات المستخدم
class UserInformationManager {
  static Future<void> saveUserInfo(String username, String phoneNumber) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': username,
        'email': user.email,
        'phoneNumber': phoneNumber,
      }, SetOptions(merge: true));
    }
  }
}
