import 'package:flutter/material.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Документы'),
      ),
      body: const Center(
        child: Text('Ваши документы будут здесь.'),
      ),
    );
  }
}
