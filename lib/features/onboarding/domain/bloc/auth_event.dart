part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class OnGoogleSigninClick extends AuthEvent {}

class OnSignupBtnClick extends AuthEvent {}

class OnSigninBtnClick extends AuthEvent {}

class OnSigninWithEmail extends AuthEvent {
  final String email;
  final String password;
  OnSigninWithEmail({
    this.email = '',
    this.password = '',
  });
}

class OnSignOut extends AuthEvent {}
