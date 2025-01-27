import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/video_consultation_screen.dart';
import 'screens/appointment_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/documents_screen.dart';
import 'screens/store_screen.dart';
import 'screens/bonus_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dental Clinic App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
          secondary: Colors.tealAccent,
          background: Colors.white,
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal[800],
          ),
          titleLarge: TextStyle(
            fontSize: 16,
            color: Colors.teal[700],
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: '/welcome', // Set the initial screen
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/': (context) => HomeScreen(),
        '/messages': (context) => MessagesScreen(),
        '/video': (context) => VideoConsultationScreen(),
        '/appointment': (context) => AppointmentScreen(),
        '/payment': (context) => PaymentScreen(),
        '/documents': (context) => DocumentsScreen(),
        '/store': (context) => StoreScreen(),
        '/bonus': (context) => BonusScreen(),
        '/auth': (context) => AuthScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
