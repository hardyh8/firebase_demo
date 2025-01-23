import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/app_colors.dart';
import '../../../routing/router_helper.dart';
import '../../../routing/routes.dart';
import '../../../utils/widgets/custom_snackbar.dart';
import '../../onboarding/domain/bloc/auth_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is SignOutFailure) {
                  CustomSnackbar.showSnackbar(
                    context: context,
                    message: 'Signout Failed : ${state.reason}',
                    type: SnackbarType.error,
                  );
                }
                if (state is SignOutSuccess) {
                  CustomSnackbar.showSnackbar(
                    context: context,
                    message: 'Signout Success',
                    type: SnackbarType.sucess,
                  );
                  RouterHelper.pushReplace(context, AppRoutes.signin.name);
                }
              },
              child: Column(
                children: [
                  ListTile(
                    onTap: () => context.read<AuthBloc>().add(OnSignOut()),
                    leading: const Icon(
                      Icons.logout_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
