import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_clinic_app/screens/messages_screen.dart';

class DoctorDashboardScreen extends StatefulWidget {
  final String doctorName;

  const DoctorDashboardScreen({Key? key, required this.doctorName}) : super(key: key);

  @override
  _DoctorDashboardScreenState createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Кабинет врача: ${widget.doctorName}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Мои пациенты и приемы',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                .collection('appointments')
                .where('specialistName', isEqualTo: widget.doctorName)
                .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var appointments = snapshot.data!.docs;
                if (appointments.isEmpty) {
                  return Center(
                    child: Text('У вас пока нет записей'),
                  );
                }

                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    var appointmentData = appointments[index].data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Text(appointmentData['userId'] ?? 'Пациент'),
                        subtitle: Text(
                          '${appointmentData['date']} в ${appointmentData['time']}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.chat),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessagesScreen(
                                  isDoctorMode: true,
                                  patientId: appointmentData['userId'],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
