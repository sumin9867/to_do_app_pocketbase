import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              // Top Row: Avatar + Icons
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFE1DFF9),
                    child: Text('B', style: TextStyle(color: Colors.black)),
                  ),
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.notifications_none)),
                ],
              ),
              const SizedBox(height: 20),

              // Greeting
              Text(
                'Hello Blossom 👋',
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

              // Task List
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    bool isCompleted = index == 1; // second one marked
                    return TaskCard(isCompleted: isCompleted);
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

class TaskCard extends StatelessWidget {
  final bool isCompleted;

  const TaskCard({super.key, this.isCompleted = false});

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
          // Title row
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

          // Bottom row
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
                    isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
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
