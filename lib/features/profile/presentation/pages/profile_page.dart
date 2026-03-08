import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jodhere/features/booking/data/models/booking_model.dart';
import 'package:jodhere/features/home/presentation/cubit/home_cubit.dart';
import 'package:jodhere/features/home/presentation/cubit/home_state.dart';
import 'package:jodhere/features/profile/presentation/pages/edit_account_details_page.dart';
import 'package:jodhere/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jodhere/features/profile/presentation/cubit/profile_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    context.read<ProfileCubit>().fetchProfile();
    context.read<HomeCubit>().fetchBookings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<HomeCubit>().refreshBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if (state.status == ProfileStatus.deleted) {
          await Supabase.instance.client.auth.signOut();

          if (!context.mounted) return;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("ลบบัญชีเรียบร้อย")));
        }
      },
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

        if (state.status == ProfileStatus.loaded && state.profile != null) {
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
                        leading: const Icon(
                          Icons.person_outline,
                          color: Colors.grey,
                        ),
                        title: const Text('แก้ไขข้อมูลส่วนตัว'),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
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

                      Divider(height: 1),

                      /// Logout
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.grey),
                        title: const Text('ออกจากระบบ'),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () async {
                          final navigator = Navigator.of(context);

                          await Supabase.instance.client.auth.signOut();

                          if (!context.mounted) return;

                          navigator.pushReplacementNamed('/login');
                        },
                      ),

                      const Divider(height: 1),

                      /// Delete Profile
                      ListTile(
                        leading: const Icon(Icons.delete, color: Colors.grey),
                        title: const Text('ลบบัญชี'),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("ยืนยันการลบบัญชี"),
                              content: const Text(
                                "คุณต้องการลบบัญชีหรือไม่ หากลบแล้ว คุณจะไม่สามารถกลับมาใช้บัญชีนี้ได้อีก",
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("ยืนยัน"),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple.shade800,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text("ยกเลิก"),
                                ),
                              ],
                            ),
                          );

                          if (!context.mounted) return;

                          if (confirmed == true) {
                            // ✅ Fetch fresh from server right now
                            final freshBookings = await context
                                .read<HomeCubit>()
                                .fetchBookings();

                            if (!context.mounted) return;

                            final activeBooking = freshBookings
                                .where(
                                  (b) =>
                                      ['PENDING', 'ARRIVED'].contains(b.status),
                                )
                                .firstOrNull;

                            debugPrint(activeBooking.toString());

                            if (activeBooking != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('กรุณายกเลิกจองก่อนลบบัญชี'),
                                ),
                              );
                              return;
                            }

                            await context.read<ProfileCubit>().deleteProfile();
                          }
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
        return const Scaffold(body: Center(child: Text("No Data")));
      },
    );
  }
}
