import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('แผนที่')),
      body: const Center(child: Text('หน้าแผนที่ (เตรียมไว้)')),
    );
  }
}
