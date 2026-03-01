import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jodhere/features/profile/presentation/pages/edit_account_details_page.dart';
import 'package:jodhere/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jodhere/features/profile/presentation/cubit/profile_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileError) {
          return Scaffold(
            body: Center(child: Text(state.message)),
          );
        }

        if (state is ProfileLoaded) {
          final profile = state.profile;

          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Profile Picture
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[300],
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // User Name
                        Text(
                          profile.displayName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Email
                        Text(
                          profile.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Rating & Trips (static for now)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  '4.8',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'คะแนนรีวิว',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32.0,
                              ),
                              child: Container(
                                width: 1,
                                height: 50,
                                color: Colors.grey[300],
                              ),
                            ),
                            Column(
                              children: [
                                const Text(
                                  '127',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'การเดินทาง',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Menu List
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline, color: Colors.grey),
                        title: const Text('แก้ไขข้อมูลส่วนตัว'),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditAccountDetailsPage(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(Icons.star_outline, color: Colors.grey),
                        title: Text('รีวิวและคะแนน'),
                        trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(Icons.settings_outlined, color: Colors.grey),
                        title: Text('การตั้งค่า'),
                        trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(Icons.help_outline, color: Colors.grey),
                        title: Text('ช่วยเหลือ'),
                        trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(Icons.info_outline, color: Colors.grey),
                        title: Text('หากคุณมีข้อเสนอ'),
                        trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      ),
                      const Divider(height: 1),

                      // Logout
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.grey),
                        title: const Text('ออกจากระบบ'),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () async {
                          final navigator = Navigator.of(context);

                          await Supabase.instance.client.auth.signOut();

                          if (!context.mounted) return;

                          navigator.pushReplacementNamed('/login');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}