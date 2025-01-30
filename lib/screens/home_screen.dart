import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/about_clinic_screen.dart';
import '../screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Личный кабинет'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const UserProfileHeader(),
          const SizedBox(height: 20),
          _buildMenuCard(
            context: context,
            title: 'Мои записи',
            icon: Icons.calendar_today,
            onTap: () => context.push('/appointments'),
          ),
          _buildMenuCard(
            context: context,
            title: 'Магазин',
            icon: Icons.shopping_cart,
            onTap: () => context.push('/shop'),
          ),
          _buildMenuCard(
            context: context,
            title: 'О клинике',
            icon: Icons.local_hospital,
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const AboutClinicScreen())
              );
            },
          ),
          _buildMenuCard(
            context: context,
            title: 'Профиль',
            icon: Icons.person,
            onTap: () => context.push('/profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/default_avatar.png'),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Иванов Иван',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Пациент',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
