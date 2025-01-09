import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'app_screens.dart';
import 'domain/refresh_schema.dart';
import 'routes.dart';

final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.signin.path,
    refreshListenable:
        GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    routes: [
      AppScreens.home,
      AppScreens.signin,
      AppScreens.forgotPsw,
    ],
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final inOnboarding = [
        AppRoutes.signin.path,
        AppRoutes.forgotPsw.path,
      ].contains(state.matchedLocation);

      if (user != null && inOnboarding) return AppRoutes.home.path;

      if (user == null && !inOnboarding) return AppRoutes.signin.path;

      return null;
    });
