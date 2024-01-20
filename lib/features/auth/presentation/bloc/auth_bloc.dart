import 'package:bloc/bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/exports.dart';
import '../../domain/usecases/update_phone_number_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // تعريف المتغيرات لعمليات المصادقة والمستودع

  final SignInWithGoogle signInWithGoogle;
  final SignOut signOut;
  final AuthRepository repository;
  final UpdatePhoneNumber updatePhoneNumber;

  // البناء الأولي لـ AuthBloc مع تعيين الوظائف والمستودعات اللازمة

  AuthBloc({
    required this.signInWithGoogle,
    required this.signOut,
    required GetCurrentUser getCurrentUser,
    required this.repository,
    required this.updatePhoneNumber,
  }) : super(AuthInitial()) {
    // تسجيل الأحداث والدوال المطابقة لها للتعامل مع كل حدث
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
    on<SaveUsernameEvent>(_onSaveUsername);
    on<UpdateUsernameEvent>(_onUpdateUsername);
    on<UpdatePhoneNumberEvent>(_onUpdatePhoneNumber);
  }

  // معالجة الأحداث المختلفة للمصادقة

  // تنفيذ عملية تسجيل الدخول باستخدام قوقل
  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signInWithGoogle.execute();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  // تنفيذ عملية تسجيل الخروج
  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    await signOut.execute();
    emit(AuthInitial());
  }

  // حفظ اسم المستخدم الجديد
  Future<void> _onSaveUsername(
      SaveUsernameEvent event, Emitter<AuthState> emit) async {
    final result = await repository.saveUsername(event.username);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(UsernameSaved()),
    );
  }

  // تحديث اسم المستخدم الحالي
  Future<void> _onUpdateUsername(
    UpdateUsernameEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
        UsernameUpdating()); // قم بإعلام واجهة المستخدم بأننا نقوم بتحديث اسم المستخدم
    try {
      await repository.updateUserName(event.username);
      emit(
          UsernameUpdated()); // قم بإعلام واجهة المستخدم باكتمال تحديث اسم المستخدم
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  // تحديث رقم الهاتف الخاص بالمستخدم
  Future<void> _onUpdatePhoneNumber(
    UpdatePhoneNumberEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
        PhoneNumberUpdating()); // قم بإعلام واجهة المستخدم بأننا نقوم بتحديث رقم الهاتف

    try {
      await updatePhoneNumber(event.phoneNumber);
      emit(
          PhoneNumberUpdated()); // قم بإعلام واجهة المستخدم باكتمال تحديث رقم الهاتف
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }
}
