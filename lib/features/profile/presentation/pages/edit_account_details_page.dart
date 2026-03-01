import 'package:flutter/material.dart';

class EditAccountDetailsPage extends StatefulWidget {
  const EditAccountDetailsPage({super.key});

  @override
  State<EditAccountDetailsPage> createState() => _EditAccountDetailsPageState();
}

class _EditAccountDetailsPageState extends State<EditAccountDetailsPage> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _displayNameController.text = 'สมชาย ใจดี';
    _emailController.text = 'somchai.jaidee@gmail.com';
    _phoneController.text = '0812345678';
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('แก้ไขข้อมูลส่วนตัว')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextField('Display Name', _displayNameController),
                  _buildTextField('Phone', _phoneController),
                  _buildTextField('Email', _emailController),
                  FilledButton(onPressed: () {}, child: const Text('แก้ไข')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
