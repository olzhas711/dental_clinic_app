import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const VerificationScreen({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger('VerificationScreen');
  bool _isLoading = false;

  void _verifyCode() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Проверка длины кода
      if (_codeController.text.length != 6) {
        _showErrorSnackBar('Код подтверждения должен содержать 6 цифр');
        return;
      }

      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _codeController.text,
      );

      _logger.info('Попытка входа с номера: ${widget.phoneNumber}');

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        _logger.info('Успешная авторизация: ${userCredential.user!.uid}');
        
        // Успешная авторизация
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Вход выполнен успешно'), 
            backgroundColor: Colors.green
          ),
        );
        context.go('/home'); // Перенаправление на домашний экран
      }
    } on FirebaseAuthException catch (e) {
      _logger.severe('Ошибка аутентификации: ${e.code}');
      
      String errorMessage;
      switch (e.code) {
        case 'invalid-verification-code':
          errorMessage = 'Неверный код подтверждения';
          break;
        case 'session-expired':
          errorMessage = 'Время сессии истекло. Запросите новый код.';
          break;
        default:
          errorMessage = 'Произошла ошибка при входе';
      }

      _showErrorSnackBar(errorMessage);
    } catch (e) {
      _logger.severe('Неизвестная ошибка: $e');
      _showErrorSnackBar('Произошла неизвестная ошибка');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), 
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        title: Text('Подтверждение номера'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Введите код подтверждения',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Отправлен на номер ${widget.phoneNumber}',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 10),
                decoration: InputDecoration(
                  hintText: '______',
                  hintStyle: TextStyle(color: Colors.white30, letterSpacing: 10),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                maxLength: 6,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : ElevatedButton(
                      onPressed: _verifyCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue[900],
                      ),
                      child: Text('Подтвердить'),
                    ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // TODO: Реализовать логику повторной отправки кода
                  _logger.info('Запрос нового кода');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Новый код будет отправлен shortly'), 
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                child: Text(
                  'Отправить код повторно', 
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
