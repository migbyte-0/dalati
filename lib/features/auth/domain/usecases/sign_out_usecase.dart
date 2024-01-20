import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  // تنفيذ عملية تسجيل الخروج
  Future<Either<Failure, void>> execute() => repository.signOut();
}
