import 'package:flutter/material.dart';
import 'package:prediksi_stress/views/RiwayatPage.dart';
import 'package:prediksi_stress/views/dashboard_page.dart';
import 'package:prediksi_stress/views/gantiPassword_page.dart';
import 'package:prediksi_stress/views/hasil_prediksi_page.dart';
import 'package:prediksi_stress/views/prediksi_page.dart';
import 'package:prediksi_stress/views/profile_page.dart';
import 'views/login_page.dart';
import 'views/register_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Stres Akademik',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/prediksi': (context) => const PrediksiPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/hasil': (context) => const HasilPrediksiPage(hasil: ''),
        '/riwayat': (context) => const RiwayatPage(),
        '/profil': (context) => const ProfilePage(),
        '/ganti-password': (context) => const GantiPasswordPage(),
      },
    );
  }
}
