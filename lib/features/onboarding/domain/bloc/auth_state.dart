part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class SignIn extends AuthState {}

final class SignUp extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthFailure extends AuthState {
  final String reason;
  AuthFailure(this.reason);
}

final class SignOutLoading extends AuthState {}

final class SignOutSuccess extends AuthState {}

final class SignOutFailure extends AuthState {
  final String reason;
  SignOutFailure(this.reason);
}

final class ForgetPasswordSuccess extends AuthState {}
