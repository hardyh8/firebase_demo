import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/onboarding/domain/bloc/auth_bloc.dart';
import '../features/onboarding/screens/sign_in.dart';
import '../main.dart';
import 'routes.dart';

class AppScreens {
  static final signin = GoRoute(
    path: AppRoutes.signin.path,
    name: AppRoutes.signin.name,
    builder: (context, state) => const SignInScreen(),
  );

  static final home = GoRoute(
    path: AppRoutes.home.path,
    name: AppRoutes.home.name,
    builder: (context, state) => BlocProvider(
      create: (context) => AuthBloc(),
      child: const MyHomePage(title: ''),
    ),
    routes: [],
  );
}
