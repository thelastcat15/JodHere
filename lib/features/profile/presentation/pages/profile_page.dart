import 'package:flutter/material.dart';
import 'package:jodhere/features/profile/presentation/pages/edit_account_details_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Picture with Camera Icon
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
                        decoration: BoxDecoration(
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
                  const Text(
                    'สมชาย ใจดี',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),

                  // Email
                  Text(
                    'somchai.jaidee@email.com',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Rating and Trip Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Rating
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
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Container(
                          width: 1,
                          height: 50,
                          color: Colors.grey[300],
                        ),
                      ),
                      // Trips
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
                    // Navigate to Edit Account Details Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditAccountDetailsPage(),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.star_outline, color: Colors.grey),
                  title: const Text('รีวิวและคะแนน'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
                ),
                Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.settings_outlined,
                    color: Colors.grey,
                  ),
                  title: const Text('การตั้งค่า'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
                ),
                Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: Colors.grey),
                  title: const Text('ช่วยเหลือ'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
                ),
                Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.grey),
                  title: const Text('หากคุณมีข้อเสนอ'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
                ),
                Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.grey),
                  title: const Text('ออกจากระบบ'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    final supabase = Supabase.instance.client;
                    supabase.auth.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
