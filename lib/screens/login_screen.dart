import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _phoneController = TextEditingController(text: '9991234567');
  final _otpController = TextEditingController(text: '123456');
  bool _isOtpSent = false;

  // Метод для очистки номера телефона
  String _formatPhoneNumber(String phone) {
    // Удаляем все нецифровые символы
    String cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    
    // Если номер начинается с 7 или 8, обрезаем первую цифру
    if (cleanPhone.startsWith('7') || cleanPhone.startsWith('8')) {
      cleanPhone = cleanPhone.substring(1);
    }
    
    return cleanPhone;
  }

  Future<void> _sendOTP() async {
    final phone = _formatPhoneNumber(_phoneController.text);
    final result = await _authService.sendOTP(phone);

    if (result) {
      setState(() {
        _isOtpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP отправлен на +7$phone'))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось отправить OTP'))
      );
    }
  }

  Future<void> _verifyOTP() async {
    final phone = _formatPhoneNumber(_phoneController.text);
    final otp = _otpController.text;

    final result = await _authService.verifyOTP(
      phone: phone, 
      token: otp
    );
    
    if (result != null) {
      final role = result['profile']['role'];
      
      // Роутинг в зависимости от роли
      switch (role) {
        case 'patient':
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 'doctor':
          Navigator.pushReplacementNamed(context, '/doctor-home');
          break;
        case 'admin':
          Navigator.pushReplacementNamed(context, '/admin-panel');
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Неизвестная роль'))
          );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Неверный OTP'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вход')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Номер телефона',
                hintText: '9991234567',
                prefixText: '+7 ',
                helperText: 'Тестовый номер: 9991234567',
              ),
              keyboardType: TextInputType.phone,
              enabled: !_isOtpSent,
            ),
            if (_isOtpSent) ...[
              SizedBox(height: 16),
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'Код подтверждения',
                  helperText: 'Тестовый код: 123456',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isOtpSent ? _verifyOTP : _sendOTP,
              child: Text(_isOtpSent ? 'Подтвердить' : 'Получить код'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            if (_isOtpSent) ...[
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isOtpSent = false;
                    _otpController.clear();
                  });
                },
                child: Text('Изменить номер'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
