import 'dart:math';

class VerificationService {
  static String generateVerificationCode({int length = 6}) {
    final random = Random();
    return List.generate(
      length, 
      (_) => random.nextInt(10).toString()
    ).join();
  }

  static bool verifyCode(String userCode, String sentCode) {
    return userCode.trim() == sentCode.trim();
  }

  static bool validatePhoneNumber(String phoneNumber) {
    // Простая валидация номера телефона
    final phoneRegex = RegExp(r'^(\+7|7|8)?[\s-]?\(?[489][0-9]{2}\)?[\s-]?[0-9]{3}[\s-]?[0-9]{2}[\s-]?[0-9]{2}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Форматирование номера телефона в едином стиле
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (phoneNumber.startsWith('8')) {
      phoneNumber = '+7' + phoneNumber.substring(1);
    } else if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+' + phoneNumber;
    }
    return phoneNumber;
  }
}
