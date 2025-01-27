import 'dart:math';
import 'package:flutter/material.dart';

class EmailVerificationService {
  static String generateVerificationCode() {
    final random = Random();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }

  static void sendVerificationCode(BuildContext context, String email) {
    final code = generateVerificationCode();
    
    // TODO: Реальная отправка кода на почту
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Код подтверждения: $code')),
    );
  }

  static bool verifyCode(String userCode, String sentCode) {
    return userCode == sentCode;
  }
}
