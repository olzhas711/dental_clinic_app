import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:dental_clinic_app/screens/landing_screen.dart';
import 'package:dental_clinic_app/screens/login_screen.dart';
import 'package:dental_clinic_app/screens/home_screen.dart';
import 'package:dental_clinic_app/screens/about_clinic_screen.dart';
import 'package:dental_clinic_app/screens/shop_screen.dart';
import 'package:dental_clinic_app/screens/appointments_screen.dart';
import 'package:dental_clinic_app/screens/profile_screen.dart';
import 'package:dental_clinic_app/screens/contact_us_screen.dart';
import 'package:dental_clinic_app/screens/tips_screen.dart';
import 'package:dental_clinic_app/screens/services_screen.dart';
import 'package:dental_clinic_app/screens/doctor_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:dental_clinic_app/providers/cart_provider.dart';
import 'package:dental_clinic_app/screens/payment_screen.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Настройка логирования
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Supabase.initialize(
      url: 'https://oxkwyrclgkpymzhvvpdy.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94a3d5cmNsZ2tweW16aHZ2cGR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgxNjI0MDAsImV4cCI6MjA1MzczODQwMH0.OIy1jJ8WTKJ-ou9HmpaYBp4TOSJ594QiNGCFD6CNCJQ',
    );
    Logger('Supabase').info('Supabase инициализирован успешно');
  } catch (e) {
    Logger('Supabase').severe('Ошибка инициализации Supabase: $e');
  }

  await initializeDateFormatting('ru_RU', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Зуб даю',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        routerConfig: _router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru', 'RU'),
        ],
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/doctor-home',
      builder: (context, state) => const DoctorHomeScreen(),
    ),
    GoRoute(
      path: '/about-clinic',
      builder: (context, state) => const AboutClinicScreen(),
    ),
    GoRoute(
      path: '/shop',
      builder: (context, state) => const ShopScreen(),
    ),
    GoRoute(
      path: '/appointments',
      builder: (context, state) => const AppointmentsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => const ContactUsScreen(),
    ),
    GoRoute(
      path: '/tips',
      builder: (context, state) => const TipsScreen(),
    ),
    GoRoute(
      path: '/services',
      builder: (context, state) => const ServicesScreen(),
    ),
    GoRoute(
      path: '/video-consultation',
      builder: (context, state) => VideoConsultationScreen(
        patientName: state.uri.queryParameters['patientName'] ?? 'Пациент',
      ),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) => const PaymentScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Страница не найдена: ${state.error}'),
    ),
  ),
);
