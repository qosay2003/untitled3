import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Usersingup extends StatelessWidget {
  const Usersingup({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr, // دعم اتجاه RTL
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('sign up'),
          titleTextStyle: TextStyle(
            color: Color(0xFF0C552E),
            fontWeight: FontWeight.w900,
            fontSize: 40,
            fontFamily: "IBMPlexSansArabic",
          ),
        ),
        backgroundColor: const Color(0xFF0C552E), // الخلفية الخضراء
        body: SingleChildScrollView(
          child: Column(
            children: [
              // الجزء العلوي المقوس
              Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(350),
                          bottomRight: Radius.circular(350)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // الحقول
              // الاسم
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الاسم',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // حجم خط التسمية
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: 'ادخل اسمك',
                        hintStyle: TextStyle(fontSize: 20),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

// البريد الإلكتروني
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'البريد الإلكتروني',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'ادخل بريدك الالكتروني',
                        hintStyle: TextStyle(fontSize: 20),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

// كلمة السر
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'كلمة السر',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      obscureText: true,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'ادخل كلمة السر',
                        hintStyle: TextStyle(fontSize: 16),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

// تأكيد كلمة السر
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'تأكيد كلمة السر',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      obscureText: true,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: 'ادخل كلمة السر مرة أخرى',
                        hintStyle: TextStyle(fontSize: 16),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // زر دخول
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFFFF),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'دخول',
                      style: TextStyle(
                        color: Color(0xFF0B5022),
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'او سجل باستخدام',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.google,
                      color: Colors.white, size: 30),
                  const SizedBox(width: 60),
                  Icon(Icons.facebook, size: 40, color: Colors.white),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, String hint, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 5),
          TextField(
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
