import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/application/task/task_state.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/infrastructure/task_repo.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/model/task_model.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepo taskRepo;

  TaskCubit(this.taskRepo) : super(TaskInitial());

  Future<void> fetchTasks(String userId) async {
    emit(TaskLoading());

    final result = await taskRepo.getAllTasks(userId);

    result.fold(
      (error) => emit(TaskError(error)),
      (tasks) => emit(TaskLoaded(tasks)),
    );
  }

  Future<void> deleteTask(String taskId) async {
    emit(TaskLoading());
    final result = await taskRepo.deleteTask(taskId);

    result.fold(
      (error) => emit(TaskError(error)),
      (success) => emit(TaskDeleted()),
    );
  }

  Future<void> markTaskAsExpired(TaskModel task) async {
    try {
      await taskRepo.updateTaskStatus(task.id, true);
    } catch (e) {
      log('Error marking task as expired: $e');
    }
  }

  Future<void> markTaskAsCompleted(String taskId) async {
    emit(TaskLoading());
    final result = await taskRepo.markTaskAsCompleted(taskId);

    result.fold(
      (error) => emit(TaskError(error)),
      (success) => emit(TaskUpdatedMarked(success)),
    );
  }

  Future<void> editTask(TaskModel task) async {
    emit(TaskLoading());
    final result = await taskRepo.editTask(task);

    result.fold(
      (error) => emit(TaskError(error)),
      (updatedTask) => emit(TaskUpdated(updatedTask)),
    );
  }
}
