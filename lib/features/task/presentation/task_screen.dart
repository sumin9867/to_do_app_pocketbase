import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/app_colors.dart';

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
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        elevation: 0,
        title: Text("Task List",style: TextStyle(fontWeight: FontWeight.bold),),
        bottom: TabBar.secondary(
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
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(all: true),
          _buildTaskList(pendingOnly: true),
          _buildTaskList(completedOnly: true),
        ],
      ),
    );
  }

  Widget _buildTaskList(
      {bool all = false,
      bool pendingOnly = false,
      bool completedOnly = false}) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: 4,
      itemBuilder: (context, index) {
        return TaskCard(
          showActions: index ==
              0, // Here you can set which card to show actions for initially
        );
      },
    );
  }
}

class TaskCard extends StatefulWidget {
  final bool isCompleted;
  final bool showActions;

  const TaskCard({
    super.key,
    this.isCompleted = false,
    this.showActions = false,
  });

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isEditing = false;

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

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
          // Title + Edit
          Row(
            children: [
              Text(
                'Exercise',
                style: GoogleFonts.roboto(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: _toggleEdit, // Toggle edit mode when tapped
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Carry out a yoga session',
            style: GoogleFonts.roboto(color: Colors.grey[600]),
          ),

          // Animated Container for expanding actions
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isEditing
                ? 56
                : 0, // Adjust the height when expanded or collapsed
            child: _isEditing
                ? Column(
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 20),
                            ),
                            child: const Text("Edit",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(60, 20),
                            ),
                            child: const Text("Delete",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),

          // Bottom row
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '10:30 PM 19 Feb, 2025',
                style:
                    GoogleFonts.roboto(fontSize: 13, color: Colors.grey[700]),
              ),
              Row(
                children: [
                  Text(
                    'Mark as completed',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.check_box_outline_blank),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
