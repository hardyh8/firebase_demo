import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/app_colors.dart';
import '../../../routing/router_helper.dart';
import '../../../routing/routes.dart';
import '../domain/bloc/auth_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void initState() {
    emailController.text = 'dhameliah48@gmail.com';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.2),
                Text(
                  'Forgot Password',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Enter Email to Reset password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withAlpha(163),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is ForgetPasswordSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Reset password link sent to email!')),
                      );
                      RouterHelper.go(context, AppRoutes.signin.name);
                    }
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(OnForgetPassword(
                            email: emailController.text.trim(),
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
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
