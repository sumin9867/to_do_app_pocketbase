import 'package:equatable/equatable.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/model/task_model.dart';

abstract class AddTaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTaskInitial extends AddTaskState {}

class AddTaskLoading extends AddTaskState {}

class AddTaskSuccess extends AddTaskState {
  final TaskModel task;

  AddTaskSuccess(this.task);

  @override
  List<Object?> get props => [task];
}

class AddTaskError extends AddTaskState {
  final String message;

  AddTaskError(this.message);

  @override
  List<Object?> get props => [message];
}
