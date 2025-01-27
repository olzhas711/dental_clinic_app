import 'package:flutter/material.dart';
import 'package:dental_clinic_app/screens/auth_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class Doctor {
  final String name;
  final String specialization;
  final String imageUrl;

  Doctor({
    required this.name,
    required this.specialization,
    required this.imageUrl,
  });
}

class VideoConsultationScreen extends StatefulWidget {
  final bool isGuest;

  const VideoConsultationScreen({
    super.key, 
    this.isGuest = false
  });

  @override
  _VideoConsultationScreenState createState() => _VideoConsultationScreenState();
}

class _VideoConsultationScreenState extends State<VideoConsultationScreen> {
  final List<Doctor> _doctors = [
    Doctor(
      name: 'Иванов Иван Иванович',
      specialization: 'Стоматолог-терапевт',
      imageUrl: 'https://example.com/doctor1.jpg', // Замените на реальную ссылку
    ),
    Doctor(
      name: 'Петрова Анна Сергеевна',
      specialization: 'Стоматолог-хирург',
      imageUrl: 'https://example.com/doctor2.jpg', // Замените на реальную ссылку
    ),
    Doctor(
      name: 'Смирнов Олег Викторович',
      specialization: 'Стоматолог-ортопед',
      imageUrl: 'https://example.com/doctor3.jpg', // Замените на реальную ссылку
    ),
  ];

  final List<String> _availableTimes = [
    '09:00', '10:00', '11:00', '12:00', 
    '13:00', '14:00', '15:00', '16:00'
  ];

  Doctor? _selectedDoctor;
  DateTime? _selectedDay;
  String? _selectedTime;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  bool _isDateAvailable(DateTime day) {
    // Исключаем выходные и прошедшие дни
    return day.weekday != DateTime.saturday && 
           day.weekday != DateTime.sunday && 
           day.isAfter(DateTime.now().subtract(Duration(days: 1)));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!_isDateAvailable(selectedDay)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Выбранная дата недоступна')),
      );
      return;
    }

    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedTime = null; // Сбрасываем выбранное время
    });
  }

  void _bookConsultation() {
    if (widget.isGuest) {
      _showAuthRequiredDialog();
    } else if (_selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите врача')),
      );
    } else if (_selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите дату')),
      );
    } else if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите время')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Консультация успешно запланирована')),
      );
    }
  }

  void _showAuthRequiredDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Требуется авторизация'),
        content: Text('Для записи на консультацию необходимо войти в аккаунт.'),
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
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Онлайн консультация'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Выберите врача',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _doctors.length,
                itemBuilder: (context, index) {
                  final doctor = _doctors[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(doctor.imageUrl),
                        radius: 30,
                        backgroundColor: Colors.teal.shade100,
                      ),
                      title: Text(
                        doctor.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        doctor.specialization,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: Radio<Doctor>(
                        value: doctor,
                        groupValue: _selectedDoctor,
                        onChanged: (Doctor? value) {
                          setState(() {
                            _selectedDoctor = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _selectedDoctor = doctor;
                        });
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                'Выберите дату',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(Duration(days: 90)),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                enabledDayPredicate: _isDateAvailable,
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.teal.shade200,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_selectedDay != null) ...[
                Text(
                  'Выберите время',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _availableTimes.map((time) {
                    return ChoiceChip(
                      label: Text(time),
                      selected: _selectedTime == time,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedTime = selected ? time : null;
                        });
                      },
                      selectedColor: Colors.teal.shade100,
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _bookConsultation,
                child: Text('Записаться на консультацию'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
