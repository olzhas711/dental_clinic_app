import 'package:flutter/material.dart';
import 'package:dental_clinic_app/screens/home_screen.dart';
import 'package:dental_clinic_app/screens/email_verification_screen.dart';
import 'package:dental_clinic_app/screens/sms_verification_screen.dart';
import 'package:dental_clinic_app/services/email_verification_service.dart';
import 'package:dental_clinic_app/services/sms_verification_service.dart';
import 'package:dental_clinic_app/screens/doctor_dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  final bool isLogin;

  const AuthScreen({super.key, this.isLogin = true});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isLogin;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isObscured = true;
  bool _isLoading = false;
  bool _useEmailVerification = true;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _toggleVerificationMethod() {
    setState(() {
      _useEmailVerification = !_useEmailVerification;
    });
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        await _login();
      } else {
        await _register();
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _login() async {
    // Здесь должна быть реальная логика аутентификации
    if (_emailController.text == 'demo@clinic.com' && 
        _passwordController.text == 'password123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(
          userName: 'Демо Пользователь',
          userEmail: _emailController.text,
        )),
      );
    } else if (_emailController.text == 'doctor@clinic.com' && 
               _passwordController.text == 'doctor123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DoctorDashboardScreen(
          doctorName: 'Доктор Иванов',
        )),
      );
    } else {
      throw 'Неверный email или пароль';
    }
  }

  Future<void> _register() async {
    if (_validateRegistrationFields()) {
      if (_useEmailVerification) {
        final verificationCode = EmailVerificationService.generateVerificationCode();
        
        EmailVerificationService.sendVerificationCode(
          context, 
          _emailController.text
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailVerificationScreen(
              email: _emailController.text,
              sentCode: verificationCode,
            ),
          ),
        );
      } else {
        final verificationCode = SMSVerificationService.generateVerificationCode();
        
        SMSVerificationService.sendSMSVerificationCode(
          context, 
          _phoneController.text
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SMSVerificationScreen(
              phoneNumber: _phoneController.text,
              sentCode: verificationCode,
              name: _nameController.text,
              email: _emailController.text,
            ),
          ),
        );
      }
    }
  }

  bool _validateRegistrationFields() {
    if (_nameController.text.isEmpty) {
      _showErrorDialog('Пожалуйста, введите имя');
      return false;
    }
    if (_phoneController.text.isEmpty) {
      _showErrorDialog('Пожалуйста, введите номер телефона');
      return false;
    }
    if (_emailController.text.isEmpty) {
      _showErrorDialog('Пожалуйста, введите email');
      return false;
    }
    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Ок'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_isLogin ? 'Вход' : 'Регистрация'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/clinic_logo.png',
                  height: 150,
                  width: 150,
                ),
                SizedBox(height: 30),
                Text(
                  _isLogin ? 'Вход в аккаунт' : 'Создание аккаунта',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 20),
                if (!_isLogin) ...[
                  _buildTextField(
                    controller: _nameController,
                    labelText: 'Полное имя',
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите имя';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneController,
                    labelText: 'Номер телефона',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите номер телефона';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                ],
                _buildTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Введите корректный email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  labelText: 'Пароль',
                  prefixIcon: Icons.lock,
                  obscureText: _isObscured,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите пароль';
                    }
                    if (value.length < 6) {
                      return 'Пароль должен быть не менее 6 символов';
                    }
                    return null;
                  },
                ),
                if (!_isLogin) ...[
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Способ подтверждения:'),
                      SizedBox(width: 10),
                      ChoiceChip(
                        label: Text('Email'),
                        selected: _useEmailVerification,
                        onSelected: (_) => _toggleVerificationMethod(),
                      ),
                      SizedBox(width: 10),
                      ChoiceChip(
                        label: Text('SMS'),
                        selected: !_useEmailVerification,
                        onSelected: (_) => _toggleVerificationMethod(),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 24),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          _isLogin ? 'Войти' : 'Зарегистрироваться',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: _toggleAuthMode,
                  child: Text(
                    _isLogin
                        ? 'Нет аккаунта? Зарегистрируйтесь'
                        : 'Уже есть аккаунт? Войдите',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          color: Colors.teal,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.teal) : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      style: TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
