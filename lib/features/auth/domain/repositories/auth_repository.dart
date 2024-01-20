import '../../../../core/error/failure.dart';
import '../entities/auth_entities.dart';
// auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  // تسجيل الدخول باستخدام قوقل
  Future<Either<Failure, User?>> signInWithGoogle();

  // تسجيل الخروج
  Future<Either<Failure, void>> signOut();

  // الحصول على المستخدم الحالي
  Stream<Either<Failure, Auth?>> get currentUser;

  // حفظ اسم المستخدم
  Future<Either<Failure, void>> saveUsername(String username);

  // تحديث اسم المستخدمi can not get enough of this no matter what i do not why this code dexaplain e vertain functionily for another team so this  is raelly cool i o
  Future<Either<Failure, void>> updateUserName(String username);

  // تحديث رقم الهاتف
  Future<Either<Failure, void>> updatePhoneNumber(String phoneNumber);
}
