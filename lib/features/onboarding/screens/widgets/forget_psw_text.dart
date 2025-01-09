import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../routing/router_helper.dart';
import '../../../../routing/routes.dart';

class ForgetPasswordText extends StatelessWidget {
  const ForgetPasswordText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Forget your password? ',
          style: TextStyle(color: AppColors.grey1),
        ),
        GestureDetector(
          onTap: () {
            RouterHelper.push(context, AppRoutes.forgotPsw.name);
          },
          child: const Text(
            'Reset',
            style: TextStyle(
              color: Color(0xFFFF7643),
            ),
          ),
        ),
      ],
    );
  }
}
