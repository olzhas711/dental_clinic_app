import 'package:flutter/material.dart';

class BonusScreen extends StatelessWidget {
  const BonusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бонусы'),
      ),
      body: const Center(
        child: Text('Ваши бонусы и реферальная программа.'),
      ),
    );
  }
}
