import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _services = const [
    const {
      'name': 'Терапия',
      'icon': Icons.medical_services,
      'description':
          'Лечение кариеса, пульпита, периодонтита. Реставрация зубов.',
      'price': 'От 2000 ₽'
    },
    const {
      'name': 'Хирургия',
      'icon': Icons.cut,
      'description': 'Удаление зубов, имплантация, костная пластика.',
      'price': 'От 5000 ₽'
    },
    const {
      'name': 'Протезирование',
      'icon': Icons.health_and_safety,
      'description': 'Коронки, виниры, съемные и несъемные протезы.',
      'price': 'От 10000 ₽'
    },
    const {
      'name': 'Гигиена',
      'icon': Icons.cleaning_services,
      'description': 'Профессиональная чистка, Air Flow, отбеливание.',
      'price': 'От 1500 ₽'
    },
    const {
      'name': 'Ортодонтия',
      'icon': Icons.straighten,
      'description': 'Брекеты, элайнеры, исправление прикуса.',
      'price': 'От 50000 ₽'
    },
    const {
      'name': 'Детская стоматология',
      'icon': Icons.child_care,
      'description': 'Лечение и профилактика для детей, щадящие методики.',
      'price': 'От 1500 ₽'
    },
    const {
      'name': 'Видеоконсультация',
      'icon': Icons.video_call,
      'description': 'Онлайн-консультация с врачом-стоматологом. '
          'Возможность получить профессиональную консультацию '
          'не выходя из дома. Включает первичный осмотр, '
          'рекомендации и план лечения.',
      'price': '1500 ₽'
    },
  ];

  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/clinic_hero.jpg'),
            fit: BoxFit.cover,
            opacity: 1.0,
          ),
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.7), Colors.blue.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text('Услуги клиники'),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildServiceCard(_services[5]),
                      const SizedBox(height: 16),
                      _buildServiceCard(_services[0]),
                      const SizedBox(height: 16),
                      _buildServiceCard(_services[1]),
                      const SizedBox(height: 16),
                      _buildServiceCard(_services[2]),
                      const SizedBox(height: 16),
                      _buildServiceCard(_services[4]),
                      const SizedBox(height: 16),
                      _buildServiceCard(_services[3]),
                      const SizedBox(height: 16),
                      _buildServiceCard(_services[6]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(service['icon'], color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  service['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            service['description'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Стоимость: ${service['price']}',
            style: TextStyle(
              color: Colors.blue.withOpacity(0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
