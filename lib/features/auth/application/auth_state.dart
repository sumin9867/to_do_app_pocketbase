import 'package:to_do_app_with_pocketbase/features/auth/model/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}
class AuthLogout extends AuthState {
  final String message;

  AuthLogout({required this.message});
}


class AuthAuthenticated extends AuthState {
  final String token;
  final UserModel user;

  AuthAuthenticated(this.token, this.user);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
