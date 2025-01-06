import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/app_colors.dart';
import '../../domain/bloc/auth_bloc.dart';

class NoAccountText extends StatefulWidget {
  const NoAccountText({
    super.key,
  });

  @override
  State<NoAccountText> createState() => _NoAccountTextState();
}

class _NoAccountTextState extends State<NoAccountText> {
  late Widget lastState = const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, int?>(
      selector: (state) {
        if (state is SignIn) {
          return 1;
        } else if (state is SignUp) {
          return 2;
        }
        return null;
      },
      builder: (context, state) {
        if (state == 2) {
          lastState = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don\'t have an account? ',
                style: TextStyle(color: AppColors.grey1),
              ),
              GestureDetector(
                onTap: () {
                  context.read<AuthBloc>().add(OnSignupBtnClick());
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color(0xFFFF7643),
                  ),
                ),
              ),
            ],
          );
        } else if (state == 1) {
          lastState = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(color: AppColors.grey1),
              ),
              GestureDetector(
                onTap: () {
                  context.read<AuthBloc>().add(OnSigninBtnClick());
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Color(0xFFFF7643),
                  ),
                ),
              ),
            ],
          );
        }
        return lastState;
      },
    );
  }
}
