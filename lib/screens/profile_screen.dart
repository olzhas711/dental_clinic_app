import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? userName;
  final String? email;
  final String? phone;

  const ProfileScreen({
    Key? key, 
    this.userName, 
    this.email, 
    this.phone
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _nameController.text = widget.userName ?? currentUser.displayName ?? '';
      _phoneController.text = widget.phone ?? '';
      // Загрузка номера телефона из Firestore
      _firestore.collection('users').doc(currentUser.uid).get().then((doc) {
        if (doc.exists) {
          setState(() {
            _phoneController.text = doc.data()?['phone'] ?? '';
          });
        }
      });
    }
  }

  void _saveUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        // Обновление имени в Firebase Auth
        await currentUser.updateDisplayName(_nameController.text);

        // Сохранение номера телефона в Firestore
        await _firestore.collection('users').doc(currentUser.uid).set({
          'name': _nameController.text,
          'phone': _phoneController.text,
        }, SetOptions(merge: true));

        setState(() {
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Профиль обновлен')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка обновления: ${e.toString()}')),
        );
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Выход'),
        content: Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            child: Text('Отмена'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: Text('Выйти'),
            onPressed: () {
              _auth.signOut();
              Navigator.of(ctx).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
                (Route<dynamic> route) => false,
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
        title: Text('Профиль'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  _saveUserData();
                } else {
                  _isEditing = true;
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Имя',
              enabled: _isEditing,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Телефон',
              enabled: _isEditing,
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 24),
          Text(
            'Мои записи',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          _buildAppointmentsList(),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList() {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Text('Войдите в систему для просмотра записей');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('appointments')
          .where('userId', isEqualTo: currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('У вас пока нет записей');
        }

        return Column(
          children: snapshot.data!.docs.map((doc) {
            var appointmentData = doc.data() as Map<String, dynamic>;
            var appointment = Appointment.fromMap(appointmentData);

            return Card(
              child: ListTile(
                title: Text('${appointment.specialistName}'),
                subtitle: Text(
                  '${appointment.date.day}.${appointment.date.month}.${appointment.date.year} в ${appointment.time}',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteAppointment(doc.id);
                  },
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _deleteAppointment(String appointmentId) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Запись удалена')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка удаления: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
