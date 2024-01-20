import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  // كلاس لتعريف أحداث المصادقة

  @override
  List<Object?> get props => [];
}

class SignInWithGoogleEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class SaveUsernameEvent extends AuthEvent {
  // حفظ اسم المستخدم

  final String username;

  SaveUsernameEvent(this.username);
}

class UpdateUsernameEvent extends AuthEvent {
  // تحديث اسم المستخدم

  final String username;

  UpdateUsernameEvent(this.username);

  @override
  List<Object?> get props => [username];
}

class UpdatePhoneNumberEvent extends AuthEvent {
  // تحديث رقم الهاتف

  final String phoneNumber;

  UpdatePhoneNumberEvent(this.phoneNumber);
}
