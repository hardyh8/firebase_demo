import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/app_colors.dart';
import '../../../config/svg_imgs.dart';
import '../domain/bloc/auth_bloc.dart';
import 'widgets/no_ac_text.dart';
import 'widgets/sign_in_form.dart';
import 'widgets/social_card.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var signInText = '';
  var welcomeText = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: BlocSelector<AuthBloc, AuthState, int>(
            selector: (state) {
              if (state is SignIn) {
                return 1;
              } else if (state is SignUp) {
                return 2;
              }
              return 0;
            },
            builder: (context, selectedState) {
              if (selectedState == 1) {
                signInText = 'Sign In';
              } else if (selectedState == 2) {
                signInText = 'Sign Up';
              }
              return Text(signInText);
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
                    BlocSelector<AuthBloc, AuthState, int>(
                      selector: (state) {
                        if (state is SignIn) {
                          return 1;
                        } else if (state is SignUp) {
                          return 2;
                        }
                        return 0;
                      },
                      builder: (context, state) {
                        if (state == 1) {
                          welcomeText = 'Welcome Back';
                        } else if (state == 2) {
                          welcomeText = 'Welcome!';
                        }
                        return Text(
                          welcomeText,
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
