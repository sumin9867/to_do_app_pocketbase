
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_with_pocketbase/features/auth/application/auth_state.dart';
import 'package:to_do_app_with_pocketbase/features/auth/infrastructure/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial());

  Future<void> loginUser(String email, String password) async {
    emit(AuthLoading());
    final result = await authRepository.loginUser(email: email, password: password);

    result.fold(
      (failure) => emit(AuthError(failure)),
      (success) => emit(AuthAuthenticated(success['token'], success['user'])),
    );
  }

  Future<void> registerUser(String email, String password, String name) async {
    emit(AuthLoading());
    final result = await authRepository.registerUser(
      email: email,
      password: password,
      name: name,
    );

    result.fold(
      (failure) => emit(AuthError(failure)),
      (success) => emit(AuthAuthenticated(success['token'], success['user'])),
    );
  }
   Future<void> logoutUser() async {
  log("message");
    emit(AuthLoading());
    final result = await authRepository.logoutUser();
    result.fold(
      (failure) => emit(AuthError(failure)),
      (success) => emit(AuthLogout(message: success)),  
    );
  }
}
