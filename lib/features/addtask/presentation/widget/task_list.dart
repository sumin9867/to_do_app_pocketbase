import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/application/task/task_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/model/task_model.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/presentation/widget/task_card.dart';

class TaskList extends StatelessWidget {
  final List<TaskModel> tasks;

  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No tasks available',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPress: () {
            _showTaskOptions(context, tasks[index]);
          },
          child: TaskCard(task: tasks[index]),
        );
      },
    );
  }

  void _showTaskOptions(BuildContext context, TaskModel task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('Edit Task'),
                onTap: () {
                  Navigator.pop(context);
                  _editTask(context, task);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete Task'),
                onTap: () {
                  // Navigator.pop(context);
                  _deleteTask(context, task);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editTask(BuildContext context, TaskModel task) {
    print("Edit task: ${task.title}");
  }

  void _deleteTask(BuildContext context, TaskModel task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<TaskCubit>().deleteTask(task.id);
                Navigator.pop(context);

          
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
