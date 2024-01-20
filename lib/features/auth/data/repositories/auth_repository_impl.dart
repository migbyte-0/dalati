import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/auth_entities.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource);

  // تسجيل الدخول باستخدام قوقل
  @override
  Future<Either<Failure, User?>> signInWithGoogle() async {
    try {
      final user = await authRemoteDataSource.signInWithGoogle();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // تسجيل الخروج
  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authRemoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // الحصول على المستخدم الحالي
  @override
  Stream<Either<Failure, Auth?>> get currentUser {
    return authRemoteDataSource.currentUser.map(
        (user) => Right(user != null ? Auth.fromFirebaseUser(user) : null));
  }

  // حفظ اسم المستخدم
  @override
  Future<Either<Failure, void>> saveUsername(String username) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': username,
          'email': user.email,
        }, SetOptions(merge: true));
        return const Right(null);
      } else {
        return const Left(ServerFailure('No user logged in'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // تحديث اسم المستخدم
  @override
  Future<Either<Failure, void>> updateUserName(String username) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update the user's display name in Firebase Authentication
        user.displayName!;
        await user.reload();

        // Optionally, update the username in Firestore as well
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': username,
        }, SetOptions(merge: true));

        return const Right(null);
      } else {
        return const Left(ServerFailure('No user logged in'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.code));
    } catch (e) {
      // General error handling
      return Left(ServerFailure(e.toString()));
    }
  }

  // تحديث رقم الهاتف
  @override
  Future<Either<Failure, void>> updatePhoneNumber(String phoneNumber) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'phoneNumber': phoneNumber,
        }, SetOptions(merge: true));
        return const Right(null);
      } else {
        return const Left(ServerFailure('No user logged in'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
