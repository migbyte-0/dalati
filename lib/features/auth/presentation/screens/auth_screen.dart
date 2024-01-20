import 'package:dalati/features/auth/presentation/screens/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/datasources/auth_remote_data_source.dart'
    as RemoteDataSource;
import '../../data/repositories/auth_repository_impl.dart' as AuthRepo;
import '../../domain/usecases/exports.dart';
import '../../domain/usecases/update_phone_number_usecase.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class AuthScreen extends StatelessWidget {
  // شاشة المصادقة الرئيسية

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تهيئة مصادر البيانات والمستودعات

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final authRemoteDataSource =
        RemoteDataSource.AuthRemoteDataSource(firebaseAuth, GoogleSignIn());
    final authRepository = AuthRepo.AuthRepositoryImpl(authRemoteDataSource);
    final getCurrentUser = GetCurrentUser(authRepository);
    final signInWithGoogle = SignInWithGoogle(authRepository);
    final signOut = SignOut(authRepository);
    final updatePhoneNumber = UpdatePhoneNumber(authRepository);

    return Scaffold(
      // تقديم واجهة المستخدم لتسجيل الدخول والخروج

      body: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          getCurrentUser: getCurrentUser,
          signInWithGoogle: signInWithGoogle,
          signOut: signOut,
          repository: authRepository,
          updatePhoneNumber: updatePhoneNumber,
        ),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const UsernameEntryScreen()),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: const SigninScreen(),
        ),
      ),
    );
  }
}
