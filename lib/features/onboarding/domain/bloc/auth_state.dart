part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class SignIn extends AuthState {}

final class SignUp extends AuthState {}

final class SignUpWithEmailLoading extends AuthState {}

final class SignUpWithEmailSuccess extends AuthState {}

final class SignUpWithEmailFailure extends AuthState {
  final String reason;
  SignUpWithEmailFailure(this.reason);
}

final class SignOutLoading extends AuthState {}

final class SignOutSuccess extends AuthState {}

final class SignOutFailure extends AuthState {
  final String reason;
  SignOutFailure(this.reason);
}
