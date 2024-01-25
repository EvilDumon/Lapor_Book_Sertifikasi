import 'package:lapor_book_sertifikasi/page/add_form_page.dart';
import 'package:lapor_book_sertifikasi/page/dashboard/dashboard_page.dart';
import 'package:lapor_book_sertifikasi/page/detail_page.dart';
import 'package:lapor_book_sertifikasi/page/login_page.dart';
import 'package:lapor_book_sertifikasi/page/register_page.dart';
import 'package:lapor_book_sertifikasi/page/splash_page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    title: 'Lapor Book',
    initialRoute: '/',
    routes: {
      '/': (context) => const SplashPage(),
      '/add': (context) => const AddFormPage(),
      '/login': (context) => const LoginPage(),
      '/detail': (context) => const DetailPage(),
      '/register': (context) => const RegisterPage(),
      '/dashboard': (context) => const DashboardPage(),
    },
  ));
}
