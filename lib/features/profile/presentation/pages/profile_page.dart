import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jodhere/features/profile/presentation/pages/edit_account_details_page.dart';
import 'package:jodhere/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jodhere/features/profile/presentation/cubit/profile_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();

    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {

        if (state.status == ProfileStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == ProfileStatus.error) {
          return Scaffold(
            body: Center(
              child: Text(state.errorMessage ?? "Something went wrong"),
            ),
          );
        }

        if (state.status == ProfileStatus.loaded &&
            state.profile != null) {

          final profile = state.profile!;

          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [

                        /// Profile Picture
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

                        /// Display Name
                        Text(
                          profile.displayName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),

                        /// Email
                        Text(
                          profile.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  /// Menu
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline,
                            color: Colors.grey),
                        title: const Text('แก้ไขข้อมูลส่วนตัว'),
                        trailing: const Icon(Icons.chevron_right,
                            color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<ProfileCubit>(),
                                child: const EditAccountDetailsPage(),
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),

                      /// Logout
                      ListTile(
                        leading:
                            const Icon(Icons.logout, color: Colors.grey),
                        title: const Text('ออกจากระบบ'),
                        trailing: const Icon(Icons.chevron_right,
                            color: Colors.grey),
                        onTap: () async {
                          final navigator = Navigator.of(context);

                          await Supabase
                              .instance.client.auth
                              .signOut();

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

        /// 💤 Initial state
        return const Scaffold(
          body: Center(child: Text("No Data")),
        );
      },
    );
  }
}