import 'package:flutter/material.dart';

class WhiteboardScreen extends StatelessWidget {
  const WhiteboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whiteboard'),
      ),
      body: const Center(
        child: Text('Whiteboard Coming Soon'),
      ),
    );
  }
} 