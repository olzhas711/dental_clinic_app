import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Платежи'),
      ),
      body: Center(
        child: Text('Обработка платежей.'),
      ),
    );
  }
}
