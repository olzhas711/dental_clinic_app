import 'package:flutter/material.dart';

class AboutClinicScreen extends StatefulWidget {
  const AboutClinicScreen({Key? key}) : super(key: key);

  @override
  _AboutClinicScreenState createState() => _AboutClinicScreenState();
}

class _AboutClinicScreenState extends State<AboutClinicScreen> {
  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'О клинике',
      'icon': Icons.local_hospital,
      'content': 'Наша стоматологическая клиника - это современный медицинский центр, основанный в 2010 году с миссией предоставления высококачественной стоматологической помощи. За годы работы мы помогли тысячам пациентов обрести здоровую и красивую улыбку.\n\n'
          'Мы гордимся нашим подходом, который сочетает передовые технологии, индивидуальный подход к каждому пациенту и высокий профессионализм нашей команды. '
          'Наша клиника оснащена современным оборудованием, позволяющим проводить диагностику и лечение с максимальной точностью и комфортом.\n\n'
          'Мы постоянно развиваемся, следим за новейшими достижениями в стоматологии и применяем самые эффективные методики лечения. '
          'Наша главная цель - не только лечить, но и предотвращать стоматологические проблемы, обеспечивая пациентам долгосрочное стоматологическое здоровье.',
    },
    {
      'title': 'Специалисты',
      'icon': Icons.people,
      'content': [
        {
          'name': 'Иванов Иван Иванович',
          'specialty': 'Главный врач, стоматолог-терапевт',
          'experience': 'Стаж работы: 15 лет',
          'imageUrl': 'assets/images/doctor1.png',
        },
        {
          'name': 'Петрова Анна Сергеевна',
          'specialty': 'Стоматолог-ортопед',
          'experience': 'Стаж работы: 12 лет',
          'imageUrl': 'assets/images/doctor2.png',
        },
      ],
    },
    {
      'title': 'Оборудование',
      'icon': Icons.precision_manufacturing,
      'content': 'В нашей клинике используется самое современное стоматологическое оборудование от ведущих мировых производителей. '
          'Наши технологии включают:\n\n'
          '• Цифровой рентген с минимальной лучевой нагрузкой\n'
          '• Интраоральные сканеры для точной диагностики\n'
          '• Лазерные системы для малоинвазивного лечения\n'
          '• Современные установки для комфортного лечения\n\n'
          'Все оборудование проходит регулярную поверку и обслуживание, что гарантирует высокое качество и безопасность медицинских услуг.',
    },
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/about.jpg'),
            fit: BoxFit.cover,
            opacity: 1.0,
          ),
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.7), Colors.blue.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('О клинике'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          body: Column(
            children: [
              // Horizontal Menu
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_menuItems.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(_menuItems[index]['title']),
                        selected: _selectedIndex == index,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        selectedColor: Colors.blue,
                        backgroundColor: Colors.white24,
                        labelStyle: TextStyle(
                          color: _selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: _selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              
              // Content Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildContent(_menuItems[_selectedIndex]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> menuItem) {
    if (menuItem['title'] == 'Специалисты') {
      return ListView(
        children: (menuItem['content'] as List).map<Widget>((doctor) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(doctor['imageUrl']),
                radius: 30,
              ),
              title: Text(
                doctor['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor['specialty']),
                  Text(
                    doctor['experience'],
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    }
    
    // For "О клинике" and "Оборудование"
    if (menuItem['title'] == 'О клинике' || menuItem['title'] == 'Оборудование') {
      return SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(8.0),
          child: Text(
            menuItem['content'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(0.9),
            ),
          ),
        ),
      );
    }
    
    // Fallback (though this should never be reached)
    return const SizedBox.shrink();
  }
}
