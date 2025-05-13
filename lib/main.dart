import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_with_pocketbase/core/get_dependencies.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/app_router.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/app_theme.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/application/add_task/add_task_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/application/task/task_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/auth/application/auth_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/user/application/user_detail_cubit.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => getIt<AuthCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<UserDetailCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<AddTaskCubit>(),
        ),
                BlocProvider(
          create: (context) => getIt<TaskCubit>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
