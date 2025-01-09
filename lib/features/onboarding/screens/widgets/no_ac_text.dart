import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/app_colors.dart';
import '../../domain/bloc/auth_bloc.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) {
        return current is SignIn || current is SignUp;
      },
      builder: (context, state) {
        if (state is SignIn) {
          return Row(
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
        } else if (state is SignUp) {
          return Row(
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
        return const Text('should not render');
      },
    );
  }
}
