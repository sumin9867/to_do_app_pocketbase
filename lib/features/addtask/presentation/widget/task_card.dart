import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/app_colors.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/application/task/task_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/model/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: GoogleFonts.roboto(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            task.description,
            style: GoogleFonts.roboto(color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('d MMMM y, hh:mm a')
                    .format(task.expiryDate ?? DateTime.now()),
                style:
                    GoogleFonts.roboto(fontSize: 13, color: Colors.grey[700]),
              ),
              Row(
                children: [
                  Text(
                    task.isCompleted ? 'Completed' : 'Mark as completed',
                    style: GoogleFonts.roboto(
                        fontSize: 13, color: Colors.grey[800]),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (!task.isCompleted) {
                        context.read<TaskCubit>().markTaskAsCompleted(
                            task.id); // Call the function when tapped
                      }
                      // Call the function when tapped
                    },
                    child: Icon(
                      task.isCompleted
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: task.isCompleted ? Colors.green : Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
