import 'package:flutter/material.dart';
import 'package:dental_clinic_app/services/email_verification_service.dart';
import 'package:dental_clinic_app/screens/home_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String sentCode;

  const EmailVerificationScreen({
    super.key, 
    required this.email, 
    required this.sentCode
  });

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  void _verifyCode() {
    setState(() {
      _isLoading = true;
    });

    final userCode = _codeController.text.trim();
    
    if (EmailVerificationService.verifyCode(userCode, widget.sentCode)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Неверный код подтверждения'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _resendCode() {
    final newCode = EmailVerificationService.generateVerificationCode();
    EmailVerificationService.sendVerificationCode(context, widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Подтверждение Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Подтверждение регистрации',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Код подтверждения отправлен на ${widget.email}',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Введите код подтверждения',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              child: _isLoading 
                ? CircularProgressIndicator() 
                : Text('Подтвердить'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _resendCode,
              child: Text('Отправить код повторно'),
            ),
          ],
        ),
      ),
    );
  }
}
