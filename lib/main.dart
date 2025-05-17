import 'package:flutter/material.dart';
import 'dart:async';
import 'package:untitled3/fhipage.dart';
import 'package:untitled3/homepage.dart';
import 'package:untitled3/mainlogin.dart';
import 'package:untitled3/shipage.dart';
import 'package:untitled3/thipaig.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        'fhi': (context) => FHiPage(),
        'shi': (context) => SHiPage(),
        'thi': (context) => THiPage(),
        'mlogin': (context) => mainlogin(),
        'homepage': (context) => Homepage(),
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
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, 'fhi');
    });
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
              Color(0xFF0B5022), // Top color (bright teal)
              Color(0xFF0B5022), // Bottom color (darker teal)
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            'img/logo.png', // ضع هنا مسار اللوغو (Path of the logo)
            width: 200, // يمكنك تعديل العرض حسب الحاجة
            height: 200,
            fit: BoxFit.contain, // يمكنك تعديل الارتفاع حسب الحاجة
          ),
        ),
      ),
    );
  }
}
