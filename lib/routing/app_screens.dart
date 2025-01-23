import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/car/data/models/car_data.dart';
import '../features/car/screens/car_details/car_detail_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/onboarding/domain/bloc/auth_bloc.dart';
import '../features/onboarding/screens/forgot_password.dart';
import '../features/onboarding/screens/sign_in.dart';
import '../utils/get_it_instance.dart';
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
    builder: (context, state) => const HomeScreen(),
    routes: [
      carDetail,
    ],
  );

  static final forgotPsw = GoRoute(
    path: AppRoutes.forgotPsw.path,
    name: AppRoutes.forgotPsw.name,
    builder: (context, state) => BlocProvider(
      create: (context) => getIt.get<AuthBloc>(),
      child: const ForgotPasswordScreen(),
    ),
    routes: [],
  );

  static final carDetail = GoRoute(
    path: AppRoutes.carDetails.path,
    name: AppRoutes.carDetails.name,
    builder: (context, state) {
      var data = state.extra as Map<String, dynamic>;
      return CarDetailsScreen(
        isEdit: data['isEdit'] as bool? ?? false,
        car: CarData.fromJson(data['data'] as Map<String, dynamic>? ?? {}),
      );
    },
    routes: [],
  );
}
