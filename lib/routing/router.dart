import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'app_screens.dart';
import 'domain/refresh_schema.dart';
import 'routes.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.signin.path,
  refreshListenable:
      GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  routes: [
    AppScreens.home,
    AppScreens.signin,
  ],
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final loggingIn = state.matchedLocation == AppRoutes.signin.path;

    if (user != null && loggingIn) return AppRoutes.home.path;

    if (user == null && !loggingIn) return AppRoutes.signin.path;

    return null;
  }
);
