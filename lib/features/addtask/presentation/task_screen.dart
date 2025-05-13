import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_with_pocketbase/core/get_dependencies.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/app_colors.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/show_snackbar.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/application/task/task_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/application/task/task_state.dart';

import 'package:to_do_app_with_pocketbase/features/addtask/model/task_model.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/presentation/widget/task_card.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/presentation/widget/task_list.dart';
import 'package:to_do_app_with_pocketbase/features/auth/infrastructure/auth_local_storage.dart';
import 'package:to_do_app_with_pocketbase/features/home/presentation/home_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
    _loadUserData();
    // Fetch all tasks when the screen is initialized
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final String? id = await getIt<AuthLocalStorage>().getUserId();
    if (id != null) {
      context.read<TaskCubit>().fetchTasks(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        label: Text(
          "Add Task",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.white),
        ),
        icon: Icon(
          Iconsax.edit_2,
          color: AppColors.background,
        ),
      ),
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        elevation: 0,
        title: Text("Task List", style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.black,
          indicatorColor: AppColors.primary,
          indicatorWeight: 2,
          labelStyle: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold), // Bold for selected tab
          unselectedLabelStyle:
              GoogleFonts.roboto(fontSize: 14), // Regular for unselected tabs
          tabs: [
            Tab(child: Text("All tasks")),
            Tab(child: Text("Pending")),
            Tab(child: Text("Completed")),
            Tab(child: Text("Expired")),
          ],
        ),
      ),
      body: BlocListener<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskUpdatedMarked) {
            showCustomSnackBar(
              context: context,
              message: 'Task marked as completed!',
              isSuccess: true,
            );
            _loadUserData();
          }

          if (state is TaskDeleted) {
            showCustomSnackBar(
              context: context,
              message: 'Task Deleted!',
              isSuccess: true,
            );
            _loadUserData();
          } else {
            showCustomSnackBar(
              context: context,
              message: 'Error Performing task Please try again!',
              isSuccess: false,
            );
          }
        },
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  TaskList(tasks: state.tasks),
                  TaskList(
                      tasks: state.tasks
                          .where((task) => !task.isCompleted)
                          .toList()), // Pending tasks
                  TaskList(
                      tasks: state.tasks
                          .where((task) => task.isCompleted)
                          .toList()), // Completed tasks
                  TaskList(
                      tasks: state.tasks
                          .where((task) => task.isExpiry)
                          .toList()), // Completed tasks
                ],
              );
            } else if (state is TaskError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Center(child: Text('No tasks available.'));
          },
        ),
      ),
    );
  }
}
