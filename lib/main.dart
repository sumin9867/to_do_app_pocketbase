import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Make sure to import flutter_bloc
import 'package:to_do_app_with_pocketbase/core/get_dependencies.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/app_router.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/app_theme.dart';
import 'package:to_do_app_with_pocketbase/features/auth/application/auth_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/user/application/user_detail_cubit.dart';

void main() {
  setupLocator(); // Set up dependencies (GetIt)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) =>
              getIt<AuthCubit>(), // Provide the AuthCubit to the widget tree
        ),
        BlocProvider(
          create: (context) => getIt<UserDetailCubit>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // Your app theme
        routerConfig: appRouter, // App router configuration
      ),
    );
  }
}
