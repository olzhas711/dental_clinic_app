import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Полезные советы'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTipCard(
            title: 'Гигиена полости рта',
            description: 'Регулярная чистка зубов - основа здоровья. Используйте зубную щетку и пасту 2 раза в день, утром и вечером.',
          ),
          _buildTipCard(
            title: 'Профилактика кариеса',
            description: 'Избегайте сладких и кислых продуктов. Употребляйте больше кальция и витамина D для укрепления зубов.',
          ),
          _buildTipCard(
            title: 'Регулярные осмотры',
            description: 'Посещайте стоматолога каждые 6 месяцев для профилактического осмотра и профессиональной чистки.',
          ),
          _buildTipCard(
            title: 'Правильное питание',
            description: 'Здоровое питание - залог здоровых зубов. Включайте в рацион продукты, богатые кальцием и витаминами.',
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard({required String title, required String description}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
