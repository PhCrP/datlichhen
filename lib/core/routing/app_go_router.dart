import 'package:datlichhen/features/doctor/presentation/pages/doctor_list_page.dart';
import 'package:datlichhen/features/patient/presentation/pages/patient_list_page.dart';
import 'package:datlichhen/features/appointment/presentation/pages/appointment_page.dart';
import 'package:datlichhen/features/notification/presentation/pages/notification_page.dart';
import 'package:datlichhen/features/profile/presentation/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'go_router_refresh_change.dart';
import 'package:datlichhen/features/home/presentation/pages/home_page.dart';
import 'package:datlichhen/features/splash/presentation/pages/splash_page.dart';
import '/features/auth/presentation/pages/sign_up_page.dart';
import '/features/auth/presentation/pages/login_page.dart';

class AppGoRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
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
      GoRoute(
        path: AppRoutes.patient,
        builder: (context, state) => const PatientListPage(),
      ),
      GoRoute(
        path: AppRoutes.appointment,
        builder: (context, state) => const AppointmentListPage(),
      ),

      GoRoute(
        path: AppRoutes.notification,
        builder: (context, state) => const NotificationPage(),
      ),

      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePage(),
      ),
    ],

    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loggedIn = user != null;
      if (state.matchedLocation == '/' ||
          state.matchedLocation == AppRoutes.splash) {
        return null;
      }
      final loggingIn =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup;
      if (!loggedIn && !loggingIn) return AppRoutes.login;

      if (loggedIn && loggingIn) return AppRoutes.home;
      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
  );

  static _getIndexForLocation(String path) {
    if (path.startsWith(AppRoutes.home)) return 0;
    return 0;
  }
}
