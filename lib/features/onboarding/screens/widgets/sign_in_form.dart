import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/svg_imgs.dart';
import '../../../../routing/router_helper.dart';
import '../../../../routing/routes.dart';
import '../../domain/bloc/auth_bloc.dart';

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: AppColors.grey1),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pswController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = 'admin@gmail.com';
    pswController.text = 'Qwasd@135';
  }

  @override
  void dispose() {
    emailController.dispose();
    pswController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                hintText: 'Enter your email',
                labelText: 'Email',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintStyle: const TextStyle(color: AppColors.grey1),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                suffix: SvgPicture.string(
                  SvgImages.mailIcon,
                ),
                border: authOutlineInputBorder,
                enabledBorder: authOutlineInputBorder,
                focusedBorder: authOutlineInputBorder.copyWith(
                    borderSide: const BorderSide(color: AppColors.primary))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: TextFormField(
              controller: pswController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintStyle: const TextStyle(color: AppColors.grey1),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  suffix: SvgPicture.string(
                    SvgImages.lockIcon,
                  ),
                  border: authOutlineInputBorder,
                  enabledBorder: authOutlineInputBorder,
                  focusedBorder: authOutlineInputBorder.copyWith(
                      borderSide: const BorderSide(color: AppColors.primary))),
            ),
          ),
          const SizedBox(height: 8),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is SignUpWithEmailSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Success!')),
                );
                RouterHelper.go(context, AppRoutes.home.name);
              }
              if (state is SignUpWithEmailFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.reason)),
                );
              }
            },
            builder: (context, state) {
              if (state is SignUpWithEmailLoading) {
                return const CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(OnSigninWithEmail(
                        email: emailController.text.trim(),
                        password: pswController.text.trim(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                child: const Text('Continue'),
              );
            },
          )
        ],
      ),
    );
  }
}
