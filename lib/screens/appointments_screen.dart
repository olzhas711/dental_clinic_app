import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<Map<String, dynamic>> _appointments = [
    {
      'id': 1,
      'date': DateTime(2024, 2, 15, 10, 0),
      'doctor': 'Иванов Иван Иванович',
      'service': 'Профилактический осмотр',
      'status': 'Ожидание'
    },
    {
      'id': 2,
      'date': DateTime(2024, 3, 5, 14, 30),
      'doctor': 'Петрова Анна Сергеевна',
      'service': 'Лечение кариеса',
      'status': 'Подтверждено'
    },
  ];

  void _showAppointmentActions(Map<String, dynamic> appointment) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Подтвердить визит'),
                onTap: () {
                  _updateAppointmentStatus(appointment['id'], 'Подтверждено');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Отменить визит'),
                onTap: () {
                  _updateAppointmentStatus(appointment['id'], 'Отменено');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: Colors.blue),
                title: const Text('Чат с врачом'),
                onTap: () {
                  _openDoctorChat(appointment['doctor']);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateAppointmentStatus(int id, String newStatus) {
    setState(() {
      final index = _appointments.indexWhere((app) => app['id'] == id);
      if (index != -1) {
        _appointments[index]['status'] = newStatus;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Статус визита изменен на: $newStatus')),
    );
  }

  void _openDoctorChat(String doctorName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Чат с $doctorName'),
        content: const Text('Функция чата находится в разработке'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showNewAppointmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новая запись'),
        content: const Text('Функция записи на прием в разработке'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _cancelAppointment(int index) {
    setState(() {
      _appointments.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Запись отменена')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои записи'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showNewAppointmentDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            locale: 'ru_RU',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                final appointment = _appointments[index];
                return AppointmentCard(
                  appointment: appointment,
                  onTap: () => _showAppointmentActions(appointment),
                  onCancel: () => _cancelAppointment(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final VoidCallback onTap;
  final VoidCallback onCancel;

  const AppointmentCard({
    Key? key, 
    required this.appointment, 
    required this.onTap,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          '${appointment['service']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Врач: ${appointment['doctor']}'),
            Text(
              'Дата: ${_formatDateTime(appointment['date'])}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Статус: ${appointment['status']}', 
              style: TextStyle(
                color: _getStatusColor(appointment['status']),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.more_vert),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: onCancel,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Подтверждено':
        return Colors.green;
      case 'Ожидание':
        return Colors.orange;
      case 'Отменено':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
