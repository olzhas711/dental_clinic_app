import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dental_clinic_app/screens/chat_screen.dart';
import 'package:dental_clinic_app/screens/video_consultation_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final List<Appointment> _appointments = [
    Appointment(
      patientName: 'Петров Петр Иванович',
      date: '15 февраля 2024, 10:00',
      procedure: 'Лечение кариеса',
      chatMessages: [
        'Здравствуйте, доктор. Беспокоит боль в зубе.',
      ],
    ),
    Appointment(
      patientName: 'Смирнова Анна Сергеевна',
      date: '22 февраля 2024, 14:30',
      procedure: 'Профилактический осмотр',
      chatMessages: [
        'Хочу проконсультироваться по гигиене полости рта.',
      ],
    ),
  ];

  void _startVideoConsultation(BuildContext context, Appointment appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoConsultationScreen(
          patientName: appointment.patientName,
        ),
      ),
    );
  }

  void _openPatientChat(Appointment appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          patientName: appointment.patientName,
          initialMessages: appointment.chatMessages,
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _appointments.length,
      itemBuilder: (context, index) {
        final appointment = _appointments[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(appointment.patientName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Дата: ${appointment.date}'),
                Text('Процедура: ${appointment.procedure}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.chat),
                  onPressed: () => _openPatientChat(appointment),
                ),
                IconButton(
                  icon: const Icon(Icons.video_call),
                  onPressed: () => _startVideoConsultation(context, appointment),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кабинет врача'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Мои приемы',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildAppointmentsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class Appointment {
  final String patientName;
  final String date;
  final String procedure;
  final List<String> chatMessages;

  Appointment({
    required this.patientName,
    required this.date,
    required this.procedure,
    this.chatMessages = const [],
  });
}

class DoctorProfileHeader extends StatelessWidget {
  const DoctorProfileHeader({Key? key}) : super(key: key);

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
              backgroundImage: AssetImage('assets/images/doctor1.png'),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Иванов Иван Иванович',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Стоматолог-терапевт',
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

class ChatDialog extends StatefulWidget {
  const ChatDialog({Key? key}) : super(key: key);

  @override
  _ChatDialogState createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Здравствуйте, доктор. Беспокоит зубная боль.',
      isDoctor: false,
    ),
    ChatMessage(
      text: 'Опишите, пожалуйста, где именно болит и какие ощущения.',
      isDoctor: true,
    ),
  ];

  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isDoctor: true,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageRow(_messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageRow(ChatMessage message) {
    return Align(
      alignment: message.isDoctor 
          ? Alignment.centerRight 
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isDoctor ? Colors.blue[100] : Colors.green[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(message.text),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Введите сообщение...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isDoctor;

  ChatMessage({required this.text, required this.isDoctor});
}

class ChatScreen extends StatefulWidget {
  final String patientName;
  final List<String> initialMessages;

  const ChatScreen({
    Key? key,
    required this.patientName,
    required this.initialMessages,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isDoctor: true,
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    _messages.addAll(widget.initialMessages.map((message) => ChatMessage(
      text: message,
      isDoctor: false,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patientName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageRow(_messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageRow(ChatMessage message) {
    return Align(
      alignment: message.isDoctor 
          ? Alignment.centerRight 
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isDoctor ? Colors.blue[100] : Colors.green[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(message.text),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Введите сообщение...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoConsultationScreen extends StatefulWidget {
  final String patientName;

  const VideoConsultationScreen({
    Key? key,
    required this.patientName,
  }) : super(key: key);

  @override
  _VideoConsultationScreenState createState() => _VideoConsultationScreenState();
}

class _VideoConsultationScreenState extends State<VideoConsultationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patientName),
      ),
      body: const Center(
        child: Text('Видеоконсультация'),
      ),
    );
  }
}

class DoctorHomeScreenOld extends StatelessWidget {
  const DoctorHomeScreenOld({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кабинет врача'),
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
          const DoctorProfileHeader(),
          const SizedBox(height: 20),
          _buildMenuCard(
            context: context,
            title: 'Пациенты',
            icon: Icons.people,
            onTap: () => _showPatientList(context),
          ),
          _buildMenuCard(
            context: context,
            title: 'Мои приемы',
            icon: Icons.calendar_today,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DoctorHomeScreen()),
            ),
          ),
          _buildMenuCard(
            context: context,
            title: 'Чат с пациентами',
            icon: Icons.chat,
            onTap: () => _showPatientChat(context),
          ),
          _buildMenuCard(
            context: context,
            title: 'Видеоконсультация',
            icon: Icons.video_call,
            onTap: () => _startVideoConsultation(context),
          ),
        ],
      ),
    );
  }

  void _showPatientList(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Список пациентов'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildPatientCard(
                context: context,
                name: 'Петров Петр Иванович',
                age: 35,
                diagnosis: 'Кариес зуба 16',
                nextAppointment: '15 февраля 2024, 10:00',
                medicalHistory: [
                  'Профилактический осмотр - 01.12.2023',
                  'Лечение кариеса - 15.01.2024',
                ],
              ),
              _buildPatientCard(
                context: context,
                name: 'Смирнова Анна Сергеевна',
                age: 28,
                diagnosis: 'Профилактический осмотр',
                nextAppointment: '22 февраля 2024, 14:30',
                medicalHistory: [
                  'Первичный осмотр - 10.11.2023',
                  'Чистка зубов - 20.12.2023',
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showPatientChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ChatDialog(),
    );
  }

  void _startVideoConsultation(BuildContext context) {
    // Навигация на экран видеоконсультации
    context.push('/video-consultation');
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

  Widget _buildPatientCard({
    required BuildContext context,
    required String name,
    required int age,
    required String diagnosis,
    required String nextAppointment,
    required List<String> medicalHistory,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Возраст: $age лет'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Диагноз: $diagnosis'),
                const SizedBox(height: 8),
                Text('Следующий прием: $nextAppointment'),
                const SizedBox(height: 8),
                const Text(
                  'История болезни:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...medicalHistory.map((history) => Text('• $history')),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Открыть чат с пациентом
                      },
                      icon: const Icon(Icons.chat),
                      label: const Text('Чат'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _startVideoConsultation(context),
                      icon: const Icon(Icons.video_call),
                      label: const Text('Видео'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
