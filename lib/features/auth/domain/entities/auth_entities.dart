import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth extends Equatable {
  // خصائص المستخدم
  final String id;
  final String name;
  final String phoneNumber;
  final String email;

//بناء المصداقية
  const Auth({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
  });

//إنشاء مصداقية من فاير بيز
  factory Auth.fromFirebaseUser(User user) {
    return Auth(
      id: user.uid,
      name: user.displayName ?? '',
      phoneNumber: user.phoneNumber ?? '',
      email: user.email ?? '',
    );
  }

  // لتجنب التكرار في البيانات
  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        email,
      ];
}
