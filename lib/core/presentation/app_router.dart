import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/scaffold_bottom_nav.dart';
import 'package:to_do_app_with_pocketbase/features/login/presentation/login_screen.dart';
import 'package:to_do_app_with_pocketbase/features/onboarding/presentation/onboarding_screen.dart';
import 'package:to_do_app_with_pocketbase/features/signUp/presentation/signup_screen.dart';



class AppRoutePath {
  
  static const String onboarding = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';


}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutePath.onboarding,
  routes: [
    GoRoute(
      path: AppRoutePath.onboarding,
      builder: (context, state) => const ScaffoldBottomNav(),
    ),
    GoRoute(
      path: AppRoutePath.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutePath.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutePath.home,
      builder: (context, state) => const ScaffoldBottomNav(),
    ),
  ],
);
