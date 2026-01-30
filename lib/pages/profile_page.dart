import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('โปรไฟล์')),
      body: const Center(child: Text('หน้าข้อมูลผู้ใช้ (เตรียมไว้)')),
    );
  }
}
