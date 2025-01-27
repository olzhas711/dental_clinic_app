import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dental_clinic_app/screens/appointment_screen.dart';
import 'package:dental_clinic_app/screens/auth_screen.dart';
import 'package:dental_clinic_app/screens/messages_screen.dart';
import 'package:dental_clinic_app/screens/profile_screen.dart';
import 'package:dental_clinic_app/screens/store_screen.dart';
import 'package:dental_clinic_app/screens/video_consultation_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool isGuest;
  final String? userName;
  final String? userEmail;
  final String? userPhone;

  const HomeScreen({
    super.key, 
    this.isGuest = false, 
    this.userName, 
    this.userEmail,
    this.userPhone
  });

  void _checkAuthAndNavigate(BuildContext context, Widget screen, bool requireAuth) {
    // Для демо-пользователя всегда разрешаем доступ
    if (FirebaseAuth.instance.currentUser?.email == 'demo@clinic.com') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
      return;
    }

    if (requireAuth && isGuest) {
      _showAuthRequiredDialog(context, screen);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }
  }

  void _showAuthRequiredDialog(BuildContext context, Widget screen) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Требуется авторизация'),
        content: Text('Для доступа к этому разделу необходимо войти в аккаунт.'),
        actions: [
          TextButton(
            child: Text('Отмена'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: Text('Войти'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              ).then((_) => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              ));
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Стоматологическая клиника "Зуб даю"'),
        actions: [
          if (!isGuest) ...[
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(userName: userName),
                  ),
                );
              },
            ),
          ],
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              _checkAuthAndNavigate(
                context, 
                MessagesScreen(), 
                false
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Добро пожаловать, ${userName ?? 'Пользователь'}!',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Image.asset(
                        'assets/images/clinic_logo.png', 
                        height: 200,
                        width: 200,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildServiceCard(
                      context,
                      'Записаться на прием',
                      Icons.calendar_today,
                      () => _checkAuthAndNavigate(
                        context, 
                        AppointmentScreen(
                          isGuest: isGuest,
                          userName: userName,
                        ),
                        true
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildServiceCard(
                      context,
                      'Онлайн консультация',
                      Icons.video_call,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoConsultationScreen(
                            isGuest: isGuest
                          )
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildServiceCard(
                      context,
                      'Стоматологический магазин',
                      Icons.shopping_cart,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreScreen(isGuest: isGuest)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
