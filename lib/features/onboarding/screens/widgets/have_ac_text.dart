import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/app_colors.dart';
import '../../domain/bloc/auth_bloc.dart';

class HaveAccountText extends StatelessWidget {
  const HaveAccountText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(color: AppColors.grey1),
        ),
        GestureDetector(
          onTap: () {
            context.read<AuthBloc>().add(OnSignupBtnClick());
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
}
