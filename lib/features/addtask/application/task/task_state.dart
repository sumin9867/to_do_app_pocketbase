// task_state.dart
import 'package:equatable/equatable.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/model/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskDeleted extends TaskState {}

class TaskUpdatedMarked extends TaskState {
  final String message;

  const TaskUpdatedMarked(this.message);
}

class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;

  const TaskLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}
