import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(SignUp()) {
    on<OnSignupBtnClick>(onSignupBtnClick);
    on<OnSigninBtnClick>(onSigninBtnClick);
    on<OnSigninWithEmail>(onSigninWithEmail);
    on<OnSignOut>(onSignOut);
  }

  void onSignupBtnClick(
    OnSignupBtnClick event,
    Emitter<AuthState> emit,
  ) {
    emit(SignIn());
  }

  void onSigninBtnClick(
    OnSigninBtnClick event,
    Emitter<AuthState> emit,
  ) {
    emit(SignUp());
  }

  Future<void> onSigninWithEmail(
    OnSigninWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final emailAddress = event.email;
      final password = event.password;
      if (state is SignUp) {
        emit(SignUpWithEmailLoading());
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
        logger.d(credential.user);
        emit(SignUpWithEmailSuccess());
      } else if (state is SignIn) {
        emit(SignUpWithEmailLoading());
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAddress, password: password);
        logger.d(credential.user);
        emit(SignUpWithEmailSuccess());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        logger.d('The password provided is too weak.');
        emit(SignUpWithEmailFailure('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        logger.d('The account already exists for that email.');
        emit(SignUpWithEmailFailure(
            'The account already exists for that email.'));
      } else if (e.code == 'user-not-found') {
        logger.d('No user found for that email.');
        emit(SignUpWithEmailFailure('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        logger.d('Wrong password provided for that user.');
        emit(SignUpWithEmailFailure('Wrong password provided for that user.'));
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
}
