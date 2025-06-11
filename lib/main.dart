import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:untitled3/fhipage.dart';
import 'package:untitled3/firebase_options.dart';
import 'package:untitled3/homepage.dart';
import 'package:untitled3/mainlogin.dart';
import 'package:untitled3/shipage.dart';
import 'package:untitled3/shopBhealthy.dart';
import 'package:untitled3/thipaig.dart';
import 'package:intl/date_symbol_data_local.dart'; // إضافة هذا لدعم التنسيق
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart'; // لدعم التعريفة

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ar', null); // تهيئة بيانات اللغة
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      home: SplashScreen(),
      routes: {
        'fhi': (context) => FHiPage(),
        'shi': (context) => SHiPage(),
        'thi': (context) => THiPage(),
        'mlogin': (context) => mainlogin(),
        'homepage': (context) => Homepage(),
        'shop': (context) => Shopbhealthy(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, 'fhi');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B5022),
              Color(0xFF0B5022),
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            'img/logo.png', // تأكد من المسار الصحيح
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
