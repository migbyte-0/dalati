import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  // كلاس لتعريف حالات المصادقة

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  // المستخدم مصادق

  final dynamic user;

  Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class UsernameSaved extends AuthState {}

class UsernameUpdating extends AuthState {}

class UsernameUpdated extends AuthState {}

class AuthError extends AuthState {
  // حالة الخطأ

  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class PhoneNumberUpdating extends AuthState {}

class PhoneNumberUpdated extends AuthState {}
