

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_with_pocketbase/features/user/infrastructure/user_detail_repo.dart';
import 'user_detail_state.dart';

class UserDetailCubit extends Cubit<UserDetailState> {
  final UserDetailRepo repo;

  UserDetailCubit(this.repo) : super(UserDetailInitial());

  Future<void> fetchUserDetail(String userId) async {
    emit(UserDetailLoading());

    final result = await repo.getUserInfo(userId);

    result.fold(
      (error) => emit(UserDetailError(error)),
      (user) => emit(UserDetailLoaded(user)),
    );
  }
}
