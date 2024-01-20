import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  // تنفيذ عملية تسجيل الدخول باستخدام Google
  Future<Either<Failure, User?>> execute() => repository.signInWithGoogle();
}
