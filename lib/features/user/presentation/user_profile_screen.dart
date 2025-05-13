import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/app_colors.dart';
import 'package:to_do_app_with_pocketbase/features/auth/infrastructure/auth_local_storage.dart';
import 'package:to_do_app_with_pocketbase/features/user/application/user_detail_cubit.dart';
import 'package:to_do_app_with_pocketbase/features/user/application/user_detail_state.dart';

import 'package:to_do_app_with_pocketbase/features/auth/model/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userId = "5wg4de150284961";

    BlocProvider.of<UserDetailCubit>(context).fetchUserDetail(userId);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        elevation: 0,
        title: const Text("Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: BlocBuilder<UserDetailCubit, UserDetailState>(
          builder: (context, state) {
            if (state is UserDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserDetailLoaded) {
              final user = state.user;
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child:
                                Icon(Icons.edit, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  _buildProfileDetailRow(Icons.person, user.name, isBold: true),
                  _buildProfileDetailRow(Icons.email, user.email),
                  _buildProfileDetailRow(Icons.info, user.name),
                  const Spacer(),
                  _buildLogoutButton(),
                  _buildDeleteAccountButton(),
                ],
              );
            } else if (state is UserDetailError) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileDetailRow(IconData icon, String value,
      {bool isBold = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: isBold ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          print("Log Out");
        },
        child: const Text(
          "Log Out",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          print("Delete Account");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          "Delete Account",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
