import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/application/add_task/add_task_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/application/task/task_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/infrastructure/task_repo.dart';
import 'package:to_do_app_with_pocketbase/features/auth/infrastructure/auth_local_storage.dart';
import 'package:to_do_app_with_pocketbase/features/auth/infrastructure/auth_repository.dart';
import 'package:to_do_app_with_pocketbase/features/auth/application/auth_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/user/application/user_detail_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/user/infrastructure/user_detail_repo.dart';

final getIt = GetIt.instance;

void setupLocator() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<AuthLocalStorage>(() => AuthLocalStorage());

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "http://10.0.2.2:8090",
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getIt<AuthLocalStorage>().getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));

    dio.interceptors.add(PrettyDioLogger(
      request: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      compact: false,
      maxWidth: 90,
    ));

    return dio;
  });

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(
        getIt<Dio>(),
        getIt<AuthLocalStorage>(),
      ));
        getIt.registerLazySingleton<TaskRepo>(() => TaskRepo(
        getIt<Dio>(),
      ));

  getIt.registerLazySingleton<AuthCubit>(
      () => AuthCubit(getIt<AuthRepository>()));

  getIt.registerLazySingleton<UserDetailRepo>(() => UserDetailRepo(
        getIt<Dio>(),
      ));
  getIt.registerLazySingleton<UserDetailCubit>(
      () => UserDetailCubit(getIt<UserDetailRepo>()));
        getIt.registerLazySingleton<AddTaskCubit>(
      () => AddTaskCubit(getIt<TaskRepo>()));
            getIt.registerLazySingleton<TaskCubit>(
      () => TaskCubit(getIt<TaskRepo>()));
}
