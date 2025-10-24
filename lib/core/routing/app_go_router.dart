import 'package:datlichhen/features/movie/presentation/pages/doctor_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'go_router_refresh_change.dart';

import '/features/auth/presentation/pages/sign_up_page.dart';
import '/features/auth/presentation/pages/login_page.dart';

class AppGoRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: AppRoutes.doctor,
        builder: (context, state) => const DoctorListPage(),
      ),
    ],
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loggedIn = user != null;
      final loggingIn =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup;
      if (!loggedIn && !loggingIn) return AppRoutes.login;

      if (loggedIn && loggingIn) return AppRoutes.doctor;
      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
  );

  static _getIndexForLocation(String path) {
    if (path.startsWith(AppRoutes.doctor)) return 0;
    return 0;
  }
}
