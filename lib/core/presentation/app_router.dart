import 'package:go_router/go_router.dart';
import 'package:to_do_app_with_pocketbase/core/get_dependencies.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/scaffold_bottom_nav.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/model/task_model.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/presentation/add_task_screen.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/presentation/edit_task_screen.dart';
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
  static const String addTask = '/addTask';
  static const String editTask = '/editTask';
}

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: AppRoutePath.onboarding,
 redirect: (context, state) async {
  final token = await getToken(); 

  final isLoggingIn = state.matchedLocation == AppRoutePath.login;
  final isSigningUp = state.matchedLocation == AppRoutePath.signup;

  if (token == null) {
    
    if (!isLoggingIn && !isSigningUp) {
      return AppRoutePath.login;
    }
  } else {
    
    if (isLoggingIn || isSigningUp) {
      return AppRoutePath.home;
    }
  }

  return null;
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
      path: AppRoutePath.addTask,
      builder: (context, state) => const AddTaskScreen(),
    ),
    GoRoute(
      path: AppRoutePath.home,
      builder: (context, state) => const ScaffoldBottomNav(),
    ),
    GoRoute(
      path: AppRoutePath.editTask,
      builder: (context, state) {
        final task = state.extra as TaskModel;
        return EditTaskScreen(taskModel: task);
      },
    ),
  ],
);
