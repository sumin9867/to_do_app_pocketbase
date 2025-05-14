import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_with_pocketbase/core/get_dependencies.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/app_colors.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/show_snackbar.dart';

import 'package:to_do_app_with_pocketbase/features/addtask/application/add_task/add_task_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/application/add_task/add_task_state.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/application/task/task_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/model/task_model.dart';
import 'package:to_do_app_with_pocketbase/features/auth/infrastructure/auth_local_storage.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  DateTime? selectedDateTime;
  bool isPriority = false;

  Future<void> _selectDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  String get formattedDateTime {
    if (selectedDateTime == null) return 'Select date and time';
    return DateFormat('dd MMMM yyyy - h:mm a').format(selectedDateTime!);
  }

  Future<void> _submitTask() async {
    final String? id = await getIt<AuthLocalStorage>().getUserId();

    final title = titleController.text.trim();
    final desc = descController.text.trim();

    final task = TaskModel(
      id: '',
      title: title,
      description: desc,
      isCompleted: false,
      isExpiry: false,
      expiryDate: selectedDateTime,
      user: id ?? "",
      isPriority: isPriority,
    );

    context.read<AddTaskCubit>().addTask(task);
  }

  InputDecoration get textFieldDecoration => InputDecoration(
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      );

  Future<void> _loadUserData() async {
    final String? id = await getIt<AuthLocalStorage>().getUserId();
    if (id != null) {
      context.read<TaskCubit>().fetchTasks(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    log("I am prority $isPriority");
    return BlocListener<AddTaskCubit, AddTaskState>(
      listener: (context, state) {
        if (state is AddTaskSuccess) {
          showCustomSnackBar(
              context: context,
              message: "Task Added Successfullly",
              isSuccess: true);
          _loadUserData();
          context.pop();
        } else if (state is AddTaskError) {
          showCustomSnackBar(
              context: context, message: state.message, isSuccess: false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F3),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF3F3F3),
          elevation: 0,
          title: const Text(
            "Add task",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Task title", style: TextStyle(fontSize: 14)),
              const SizedBox(height: 6),
              TextField(
                controller: titleController,
                decoration:
                    textFieldDecoration.copyWith(hintText: "eg Buy a bike"),
              ),
              const SizedBox(height: 16),
              const Text("Task description", style: TextStyle(fontSize: 14)),
              const SizedBox(height: 6),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: textFieldDecoration,
              ),
              const SizedBox(height: 16),
              const Text("Set deadline", style: TextStyle(fontSize: 14)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _selectDateTime,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: textFieldDecoration.copyWith(
                      hintText: formattedDateTime,
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child:
                        Text("Set as priority", style: TextStyle(fontSize: 14)),
                  ),
                  Checkbox(
                    shape: const CircleBorder(),
                    value: isPriority,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        isPriority = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              const Spacer(),
              BlocBuilder<AddTaskCubit, AddTaskState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is AddTaskLoading ? null : _submitTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: state is AddTaskLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Add task",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
