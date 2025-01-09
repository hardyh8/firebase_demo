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

class OnSigninWithGoogle extends AuthEvent {}

class OnSigninWithFacebook extends AuthEvent {}

class OnForgetPassword extends AuthEvent {
  final String email;
  OnForgetPassword({
    this.email = '',
  });
}
