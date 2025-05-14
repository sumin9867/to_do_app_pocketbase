import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:to_do_app_with_pocketbase/core/get_dependencies.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/app_colors.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/application/task/task_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/application/task/task_state.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/model/task_model.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/presentation/widget/task_list.dart';
import 'package:to_do_app_with_pocketbase/features/auth/infrastructure/auth_local_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {

  
 @override
  void initState() {
    super.initState();
    _loadUserData();
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFE1DFF9),
             child: Icon(
  Iconsax.pen_add,  // Use the profile icon from Iconsax
  color: Colors.black,  // Set the color to black
  size: 30,  // Set the size of the icon
),
                  ),
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none)),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Good Morning 👋',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Let’s get started keeping your tasks organized',
                style: GoogleFonts.roboto(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 60),
              Expanded(
                child: BlocBuilder<TaskCubit, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is TaskLoaded) {
                      final now = DateTime.now();
                      final inThreeDays = now.add(Duration(days: 3));

                      final filteredTasks = state.tasks
                          .where((task) {
                            final isPriorityValid =
                                task.isPriority && !task.isExpiry;
                            final isExpiringSoon = task.expiryDate != null &&
                                !task.isExpiry &&
                                task.expiryDate!.isAfter(now) &&
                                task.expiryDate!.isBefore(inThreeDays);
                            return isPriorityValid || isExpiringSoon;
                          })
                          .toSet()
                          .toList();

                 
              

                      return TaskList(tasks: filteredTasks);
                    } else if (state is TaskError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return Center(child: Text('No tasks available.'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskCardHome extends StatelessWidget {
  final bool isCompleted;

  const TaskCardHome({super.key, this.isCompleted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Exercise',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Icon(Icons.edit, size: 18, color: Colors.grey[700]),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Carry out a yoga session',
            style: GoogleFonts.roboto(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '10:30 PM 19 Feb, 2025',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Mark as completed',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: isCompleted ? Colors.green : Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isCompleted
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: isCompleted ? Colors.green : Colors.grey,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
