import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dental_clinic_app/screens/login_screen.dart';
import 'package:dental_clinic_app/screens/services_screen.dart';
import 'package:dental_clinic_app/screens/shop_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  void _showAboutClinic(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('О клинике "Зуб даю"'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Наша клиника - это современный стоматологический центр, '
                'где каждый пациент получает высококачественную и заботливую '
                'стоматологическую помощь. Мы используем передовые технологии '
                'и индивидуальный подход к каждому пациенту.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Контактная информация:',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Адрес: ул. Стоматологов, д. 10',
                textAlign: TextAlign.center,
              ),
              Text(
                'Телефон: +7 (999) 123-45-67',
                textAlign: TextAlign.center,
              ),
              Text(
                'Email: info@zubdayu.ru',
                textAlign: TextAlign.center,
              ),
              Text(
                'Часы работы: Пн-Пт 9:00-20:00, Сб 10:00-16:00',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton({
    required BuildContext context,
    required String title,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  textBaseline: TextBaseline.alphabetic,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'Зуб даю',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Ваша улыбка - наша забота',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(3.0, 3.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        _buildServiceButton(
                          context: context,
                          title: 'О клинике',
                          onPressed: () => context.push('/about-clinic'),
                        ),
                        _buildServiceButton(
                          context: context,
                          title: 'Услуги',
                          onPressed: () => context.push('/services'),
                        ),
                        _buildServiceButton(
                          context: context,
                          title: 'Магазин',
                          onPressed: () => context.push('/shop'),
                        ),
                        _buildServiceButton(
                          context: context,
                          title: 'Советы',
                          onPressed: () => context.push('/tips'),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => context.push('/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(120, 50),
                          ),
                          child: const Text('Вход'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => context.push('/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(120, 50),
                          ),
                          child: const Text('Регистрация'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
