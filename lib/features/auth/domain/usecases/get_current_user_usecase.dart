import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/failure.dart';
import '../entities/auth_entities.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;
  GetCurrentUser(this.repository);

  // تنفيذ للحصول على المستخدم الحالي
  Stream<Either<Failure, Auth?>> execute() {
    return repository.currentUser
        .map((auth) =>
            right<Failure, Auth?>(auth as Auth?)) // Maps data to Right
        .handleError((error) {
      // التعامل مع الأخطاء
      if (error is FirebaseAuthException) {
        return left<Failure, Auth?>(
            ServerFailure(error.message ?? 'Firebase auth error'));
      } else {
        return left<Failure, Auth?>(
            const DatabaseFailure('Unknown database error'));
      }
    }, test: (e) => e is Exception) // Ensures only Exception types are handled
        .transform(StreamTransformer.fromHandlers(
            handleError: (error, stackTrace, sink) {
      // التعامل مع الأخطاء الغير متوقعة

      sink.add(
          left<Failure, Auth?>(const GenericFailure('Unknown error occurred')));
    }));
  }
}
