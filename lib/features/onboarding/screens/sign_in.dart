import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/app_colors.dart';
import '../../../config/svg_imgs.dart';
import '../domain/bloc/auth_bloc.dart';
import 'widgets/no_ac_text.dart';
import 'widgets/sign_in_form.dart';
import 'widgets/social_card.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) {
              return current is SignIn || current is SignUp;
            },
            builder: (context, selectedState) {
              if (selectedState is SignIn) {
                return const Text('Sign In');
              } else if (selectedState is SignUp) {
                return const Text('Sign Up');
              }
              return const Text('no');
            },
          ),
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (previous, current) {
                        return current is SignIn || current is SignUp;
                      },
                      builder: (context, state) {
                        return Text(
                          state is SignIn ? 'Welcome Back' : 'Welcome',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Use your email and password  \nor continue with social media',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.grey1),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    const SignInForm(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocalCard(
                          icon: SvgPicture.string(SvgImages.googleIcon),
                          press: () {},
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SocalCard(
                            icon: SvgPicture.string(SvgImages.facebookIcon),
                            press: () {},
                          ),
                        ),
                        SocalCard(
                          icon: SvgPicture.string(SvgImages.twitterIcon),
                          press: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const NoAccountText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
