import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/app_colors.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/presentation/add_task_screen.dart';
import 'package:to_do_app_with_pocketbase/features/home/presentation/home_screen.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/presentation/task_screen.dart';
import 'package:to_do_app_with_pocketbase/features/user/presentation/user_profile_screen.dart';

class ScaffoldBottomNav extends StatefulWidget {
  const ScaffoldBottomNav({super.key});

  @override
  State<ScaffoldBottomNav> createState() => _ScaffoldBottomNavState();
}

class _ScaffoldBottomNavState extends State<ScaffoldBottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    AddTaskScreen(),
    TaskScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(Iconsax.home) // Home icon without "_copy"
                : const Icon(Iconsax.home_2_copy),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? const Icon(Iconsax.add_circle) // Add Task icon without "_copy"
                : const Icon(Iconsax.add_circle_copy),
            label: 'Add Tasks',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? const Icon(Iconsax.task_square) // Tasks icon without "_copy"
                : const Icon(Iconsax.task_square_copy),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? const Icon(Iconsax.profile_circle) // Profile icon without "_copy"
                : const Icon(Iconsax.profile_circle_copy),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
