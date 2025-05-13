import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/infrastructure/task_repo.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/model/task_model.dart';

import 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final TaskRepo taskRepo;

  AddTaskCubit(this.taskRepo) : super(AddTaskInitial());

  Future<void> addTask(TaskModel task) async {
    emit(AddTaskLoading());

    final result = await taskRepo.addTask(task);

    result.fold(
      (error) => emit(AddTaskError(error)),
      (task) => emit(AddTaskSuccess(task)),
    );
  }
}
