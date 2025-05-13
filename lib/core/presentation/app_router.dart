import 'package:go_router/go_router.dart';
import 'package:to_do_app_with_pocketbase/core/get_dependencies.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/scaffold_bottom_nav.dart';
import 'package:to_do_app_with_pocketbase/features/auth/infrastructure/auth_local_storage.dart';
import 'package:to_do_app_with_pocketbase/features/auth/presentation/login_screen.dart';
import 'package:to_do_app_with_pocketbase/features/onboarding/presentation/onboarding_screen.dart';
import 'package:to_do_app_with_pocketbase/features/auth/presentation/signup_screen.dart';

Future<String?> getToken() async {
  return await getIt<AuthLocalStorage>().getToken();
}

class AppRoutePath {
  static const String onboarding = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutePath.onboarding,
  redirect: (context, state) async {
    final String? token = await getToken();

    if (token != null && token.isNotEmpty) {
      return AppRoutePath.home;
    } else {
      return AppRoutePath.login;
    }
  },
  routes: [
    GoRoute(
      path: AppRoutePath.onboarding,
      builder: (context, state) => const OnboardingScreen(),
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
