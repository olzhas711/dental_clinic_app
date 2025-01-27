import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dental_clinic_app/screens/auth_screen.dart';
import '../models/appointment.dart';

class Specialist {
  final String name;
  final String specialization;
  final String imageUrl;

  Specialist({
    required this.name,
    required this.specialization,
    required this.imageUrl,
  });
}

class AppointmentScreen extends StatefulWidget {
  final bool isGuest;
  final String? userName;

  const AppointmentScreen({
    super.key, 
    this.isGuest = false,
    this.userName,
  });

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final List<Specialist> _specialists = [
    Specialist(
      name: 'Иванов Иван Иванович',
      specialization: 'Стоматолог-терапевт',
      imageUrl: 'assets/images/doctor1.png',
    ),
    Specialist(
      name: 'Петрова Анна Сергеевна',
      specialization: 'Стоматолог-хирург',
      imageUrl: 'assets/images/doctor2.png',
    ),
    Specialist(
      name: 'Смирнов Олег Викторович',
      specialization: 'Стоматолог-ортопед',
      imageUrl: 'assets/images/doctor3.png',
    ),
  ];

  Specialist? _selectedSpecialist;
  DateTime? _selectedDate;
  String? _selectedTime;

  void _selectSpecialist(Specialist specialist) {
    setState(() {
      _selectedSpecialist = specialist;
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _selectTime(String time) {
    setState(() {
      _selectedTime = time;
    });
  }

  void _saveAppointment() async {
    if (_selectedSpecialist == null || 
        _selectedDate == null || 
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
      return;
    }

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      
      // Для гостевого режима создаем временного пользователя
      if (widget.isGuest) {
        await _showGuestBookingDialog();
        return;
      }

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Необходимо авторизоваться')),
        );
        return;
      }

      Appointment newAppointment = Appointment(
        userId: currentUser.uid,
        specialistName: _selectedSpecialist!.name,
        date: _selectedDate!,
        time: _selectedTime!,
        type: 'Очный прием',
      );

      // Сохраняем в Firestore
      await FirebaseFirestore.instance
          .collection('appointments')
          .add(newAppointment.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Запись успешно создана!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    }
  }

  Future<void> _showGuestBookingDialog() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Бронирование для гостя'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Ваше имя',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Номер телефона',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Забронировать'),
              onPressed: () async {
                if (nameController.text.isEmpty || phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Пожалуйста, заполните все поля')),
                  );
                  return;
                }

                Appointment guestAppointment = Appointment(
                  userId: null, // Для гостевых бронирований
                  specialistName: _selectedSpecialist!.name,
                  date: _selectedDate!,
                  time: _selectedTime!,
                  type: 'Очный прием',
                );

                await FirebaseFirestore.instance
                    .collection('guest_appointments')
                    .add({
                  ...guestAppointment.toMap(),
                  'guestName': nameController.text,
                  'guestPhone': phoneController.text,
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Запись успешно создана!')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _bookAppointment() {
    if (widget.isGuest) {
      _showAuthRequiredDialog();
    } else if (_selectedSpecialist == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите специалиста')),
      );
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите дату')),
      );
    } else if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите время')),
      );
    } else {
      _saveAppointment();
    }
  }

  void _showAuthRequiredDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Требуется авторизация'),
        content: Text('Для записи на прием необходимо войти в аккаунт.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Запись на прием'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Привет, ${widget.userName ?? 'Пользователь'}!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Выберите специалиста',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _specialists.length,
                  itemBuilder: (context, index) {
                    final specialist = _specialists[index];
                    return GestureDetector(
                      onTap: () => _selectSpecialist(specialist),
                      child: Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedSpecialist == specialist 
                              ? Colors.teal 
                              : Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(specialist.imageUrl),
                            ),
                            SizedBox(height: 8),
                            Text(
                              specialist.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Выберите дату',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(Duration(days: 30)),
                focusedDay: DateTime.now(),
                calendarFormat: CalendarFormat.week,
                selectedDayPredicate: (day) {
                  return _selectedDate != null && 
                    isSameDay(_selectedDate!, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  _selectDate(selectedDay);
                },
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Выберите время',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  '09:00', '10:00', '11:00', '12:00', 
                  '13:00', '14:00', '15:00', '16:00'
                ].map((timeStr) {
                  return ChoiceChip(
                    label: Text(timeStr),
                    selected: _selectedTime == timeStr,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedTime = selected ? timeStr : null;
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _bookAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Записаться',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
