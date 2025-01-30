import 'package:flutter/material.dart';

class PromotionsAndBonusesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _promotions = [
    {
      'title': 'Первичный осмотр бесплатно',
      'description': 'При первом посещении клиники - бесплатная консультация',
      'discount': '100%',
      'validUntil': '31 марта 2024',
    },
    {
      'title': 'Скидка на профессиональную гигиену',
      'description': 'Комплексная чистка зубов со скидкой',
      'discount': '20%',
      'validUntil': '28 февраля 2024',
    },
  ];

  final List<Map<String, dynamic>> _bonuses = [
    {
      'title': 'Бонусные баллы за лечение',
      'description': 'Начисляем 5% от стоимости лечения бонусами',
      'points': '500 баллов',
    },
    {
      'title': 'Реферальная программа',
      'description': 'Приведи друга и получи скидку 10%',
      'points': 'До 1000 баллов',
    },
  ];

  const PromotionsAndBonusesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Акции и бонусы'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Текущие акции'),
          ..._promotions.map((promo) => _buildPromoCard(promo)).toList(),
          const SizedBox(height: 20),
          _buildSectionTitle('Бонусная программа'),
          ..._bonuses.map((bonus) => _buildBonusCard(bonus)).toList(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPromoCard(Map<String, dynamic> promo) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          promo['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(promo['description']),
            const SizedBox(height: 8),
            Text(
              'Скидка: ${promo['discount']}',
              style: TextStyle(color: Colors.green.shade700),
            ),
            Text('Действительно до: ${promo['validUntil']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildBonusCard(Map<String, dynamic> bonus) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          bonus['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bonus['description']),
            const SizedBox(height: 8),
            Text(
              'Баллы: ${bonus['points']}',
              style: TextStyle(color: Colors.blue.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
