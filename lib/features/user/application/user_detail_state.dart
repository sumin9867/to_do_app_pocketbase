// user_detail_state.dart

import 'package:equatable/equatable.dart';
import 'package:to_do_app_with_pocketbase/features/auth/model/user_model.dart';

abstract class UserDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoading extends UserDetailState {}

class UserDetailLoaded extends UserDetailState {
  final UserModel user;

  UserDetailLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserDetailError extends UserDetailState {
  final String message;

  UserDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
