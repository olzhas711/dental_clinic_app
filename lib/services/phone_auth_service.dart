import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import '../screens/verification_screen.dart';

class PhoneAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Logger _logger = Logger('PhoneAuthService');  // Статический логгер

  // Обновленное определение тестовых аккаунтов с усиленной безопасностью
  static final Map<String, Map<String, dynamic>> testAccounts = {
    '9991234567': {
      'phone': '9991234567',
      'passwordHash': _hashPassword('patient123'),
      'name': 'Тестовый Пациент',
      'role': 'patient', 
      'email': 'patient@test.com'
    },
    '9999876543': {
      'phone': '9999876543',
      'passwordHash': _hashPassword('doctor456'),
      'name': 'Тестовый Врач',
      'role': 'doctor', 
      'email': 'doctor@test.com'
    }
  };

  // Безопасное хеширование пароля
  static String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Улучшенная валидация номера телефона
  static bool _isValidPhoneNumber(String phoneNumber) {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');
    return cleanPhone.length == 10 || 
           (cleanPhone.length == 11 && (cleanPhone.startsWith('7') || cleanPhone.startsWith('8')));
  }

  // Форматирование номера телефона в международном формате
  static String formatPhoneNumber(String phoneNumber) {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    // Удаляем начальную '8' или '7', если она есть
    final normalizedPhone = cleanPhone.startsWith('8') 
      ? cleanPhone.substring(1) 
      : (cleanPhone.startsWith('7') ? cleanPhone.substring(1) : cleanPhone);
    
    // Добавляем код страны '+7'
    return '+7$normalizedPhone';
  }

  // Безопасный вход с улучшенной обработкой ошибок
  static Future<User?> signInWithPhoneNumber(
    BuildContext context, 
    String phoneNumber, 
    {String? password}
  ) async {
    try {
      final cleanPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');
      _logger.info('Попытка входа с номером: $cleanPhone');

      // Проверка формата номера телефона
      if (!_isValidPhoneNumber(phoneNumber)) {
        _showErrorSnackBar(context, 'Некорректный формат номера телефона');
        return null;
      }

      // Проверка тестовых аккаунтов
      final testAccount = testAccounts.values.firstWhere(
        (account) => account['phone'] == cleanPhone,
        orElse: () => {},
      );

      if (testAccount.isNotEmpty) {
        // Безопасная проверка пароля с использованием хеша
        if (password == null || 
            _hashPassword(password) != testAccount['passwordHash']) {
          _showErrorSnackBar(context, 'Неверный номер телефона или пароль');
          return null;
        }

        // Создание тестового пользователя
        return await _createTestUser(testAccount);
      } else {
        // Реальная аутентификация по номеру телефона
        return await _performPhoneAuthentication(context, cleanPhone);
      }
    } catch (e) {
      _logger.severe('Ошибка входа: $e');
      _showErrorSnackBar(context, 'Произошла ошибка при входе');
      return null;
    }
  }

  // Создание тестового пользователя
  static Future<User?> _createTestUser(Map<String, dynamic> testAccount) async {
    try {
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(testAccount['name']);
        await user.updateEmail(testAccount['email']);

        _logger.info('Создан тестовый пользователь: ${user.uid}');
        return user;
      }

      return null;
    } catch (e) {
      _logger.severe('Ошибка создания тестового пользователя: $e');
      return null;
    }
  }

  // Аутентификация по номеру телефона
  static Future<User?> _performPhoneAuthentication(
    BuildContext context, 
    String cleanPhone
  ) async {
    final completer = Completer<User?>();
    
    final formattedPhone = formatPhoneNumber(cleanPhone);
    
    // Проверка тестового аккаунта перед Firebase-аутентификацией
    final testAccount = testAccounts.values.firstWhere(
      (account) => account['phone'] == cleanPhone,
      orElse: () => {},
    );

    if (testAccount.isNotEmpty) {
      // Принудительная аутентификация для тестовых аккаунтов
      return await _createTestUser(testAccount);
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            final userCredential = await _auth.signInWithCredential(credential);
            completer.complete(userCredential.user);
          } catch (e) {
            _logger.severe('Ошибка входа по credentials: $e');
            completer.complete(null);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          _logger.severe('Ошибка верификации номера: ${e.message}');
          _showErrorSnackBar(context, 'Не удалось проверить номер телефона');
          completer.complete(null);
        },
        codeSent: (String verificationId, int? resendToken) {
          // Переход на экран верификации
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VerificationScreen(
                verificationId: verificationId, 
                phoneNumber: formattedPhone
              )
            )
          );
          completer.complete(null);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          completer.complete(null);
        },
      );
    } catch (e) {
      _logger.severe('Ошибка при аутентификации: $e');
      _showErrorSnackBar(context, 'Не удалось выполнить аутентификацию');
      completer.complete(null);
    }

    return completer.future;
  }

  // Показ ошибки через SnackBar
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void _handleFirebaseAuthError(BuildContext context, FirebaseAuthException e) {
    String errorMessage = 'Неизвестная ошибка';
    
    switch (e.code) {
      case 'invalid-phone-number':
        errorMessage = 'Некорректный номер телефона';
        break;
      case 'too-many-requests':
        errorMessage = 'Слишком много попыток. Попробуйте позже';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Вход по телефону не разрешен';
        break;
      case 'configuration-not-found':
        errorMessage = 'Ошибка конфигурации Firebase. Обратитесь к администратору';
        break;
      default:
        errorMessage = e.message ?? 'Неизвестная ошибка';
    }

    _showErrorSnackBar(context, errorMessage);
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  static bool isTestAccount(User? user) {
    return testAccounts.values.any(
      (account) => account['phone'] == user?.phoneNumber,
    );
  }

  static String? getUserRole(User? user) {
    final account = testAccounts.values.firstWhere(
      (account) => account['phone'] == user?.phoneNumber,
      orElse: () => {},
    );
    return account['role'];
  }
}
