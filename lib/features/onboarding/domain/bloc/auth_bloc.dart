import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../utils/logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(SignUp()) {
    on<OnSignupBtnClick>(onSignupBtnClick);
    on<OnSigninBtnClick>(onSigninBtnClick);
    on<OnSigninWithEmail>(onSigninWithEmail);
    on<OnSigninWithGoogle>(onSigninWithGoogle);
    on<OnSigninWithFacebook>(onSigninWithFacebook);
    on<OnSignOut>(onSignOut);
    on<OnForgetPassword>(onForgetPassword);
  }

  void onSignupBtnClick(
    OnSignupBtnClick event,
    Emitter<AuthState> emit,
  ) {
    emit(SignUp());
  }

  void onSigninBtnClick(
    OnSigninBtnClick event,
    Emitter<AuthState> emit,
  ) {
    emit(SignIn());
  }

  Future<void> onSigninWithEmail(
    OnSigninWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final emailAddress = event.email;
      final password = event.password;
      if (state is SignUp) {
        emit(AuthLoading());
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
        logger.d(credential.user);
        credential.user?.sendEmailVerification();
        emit(AuthSuccess());
      } else if (state is SignIn) {
        emit(AuthLoading());
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAddress, password: password);
        logger.d(credential.user);
        emit(AuthSuccess());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        logger.d('The password provided is too weak.');
        emit(AuthFailure('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        logger.d('The account already exists for that email.');
        emit(AuthFailure('The account already exists for that email.'));
      } else if (e.code == 'user-not-found') {
        logger.d('No user found for that email.');
        emit(AuthFailure('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        logger.d('Wrong password provided for that user.');
        emit(AuthFailure('Wrong password provided for that user.'));
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> onSignOut(
    OnSignOut event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(SignOutLoading());
      await FirebaseAuth.instance.signOut();
      emit(SignOutSuccess());
    } on FirebaseAuthException catch (e) {
      logger.d('Signout failed $e');
      emit(SignOutFailure(e.message ?? ''));
    }
  }

  Future<void> onSigninWithGoogle(
    OnSigninWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);

      logger.d(user.user);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? ''));
      logger.d(e);
    }
  }

  Future<void> onSigninWithFacebook(
    OnSigninWithFacebook event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(
              loginResult.accessToken?.tokenString ?? '');

      var user = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      logger.d(user.user);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? ''));
      logger.d(e);
    }
  }

  void onForgetPassword(
    OnForgetPassword event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: event.email,
      );
      emit(ForgetPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      logger.d(e);
      if (e.code == 'auth/invalid-email') {
        logger.d('The email provided is invalid');
        emit(AuthFailure('The email provided is invalid'));
      } else if (e.code == 'auth/user-not-found') {
        logger.d('No account with this email');
        emit(AuthFailure('No account with this email.'));
      }
    }
  }
}
