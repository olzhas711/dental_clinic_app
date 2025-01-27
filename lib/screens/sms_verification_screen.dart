import 'package:flutter/material.dart';
import 'package:dental_clinic_app/services/sms_verification_service.dart';
import 'package:dental_clinic_app/screens/home_screen.dart';

class SMSVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String sentCode;
  final String? name;
  final String? email;

  const SMSVerificationScreen({
    super.key, 
    required this.phoneNumber, 
    required this.sentCode,
    this.name,
    this.email,
  });

  @override
  _SMSVerificationScreenState createState() => _SMSVerificationScreenState();
}

class _SMSVerificationScreenState extends State<SMSVerificationScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  void _verifySMSCode() {
    setState(() {
      _isLoading = true;
    });

    final userCode = _codeController.text.trim();
    
    if (SMSVerificationService.verifyCode(userCode, widget.sentCode)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userName: widget.name,
            userEmail: widget.email,
            userPhone: widget.phoneNumber,
          ),
        ),
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
    final newCode = SMSVerificationService.generateVerificationCode();
    SMSVerificationService.sendSMSVerificationCode(context, widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Подтверждение номера телефона'),
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
              'Код подтверждения отправлен на ${widget.phoneNumber}',
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
              onPressed: _isLoading ? null : _verifySMSCode,
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
