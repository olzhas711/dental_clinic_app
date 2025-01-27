import 'dart:math';
import 'package:flutter/material.dart';

class SMSVerificationService {
  static String generateVerificationCode() {
    final random = Random();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }

  static void sendSMSVerificationCode(BuildContext context, String phoneNumber) {
    final code = generateVerificationCode();
    
    // TODO: Реальная отправка SMS через провайдера
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Код подтверждения для $phoneNumber: $code')),
    );
  }

  static bool verifyCode(String userCode, String sentCode) {
    return userCode == sentCode;
  }
}
