import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/forgetpass2.dart';

// ignore: camel_case_types
class forgetpass1 extends StatelessWidget {
  const forgetpass1({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B5022),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFF0B5022), // لون الخلفية الأخضر
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                child: Image.asset(
                  'img/logo.png', // ضع هنا مسار اللوغو (Path of the logo)
                  width: 300, // يمكنك تعديل العرض حسب الحاجة
                  height: 300, // يمكنك تعديل الارتفاع حسب الحاجة
                ),
              ),
            ),
            SizedBox(height: 00),
            // النص الأول
            Text(
              'نسيت كلمه السر',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: "IBMPlexSansArabic",
              ),
            ),
            SizedBox(height: 30),
            // النص التوضيحي
            Text(
              '.لا تقلق !ادخل عنوان بريدك الإلكتروني أدناه و سنرسل لك رمزاَ لإعاده تعين كلمة السر',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "IBMPlexSansArabic",
              ),
            ),
            SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Text(
                    'البريد الالكتوني',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "IBMPlexSansArabic",
                    ),
                  ),
                ),
              ],
            ),
            // حقل إدخال البريد الإلكتروني
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: email,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'ادخل البريد الإلكتروني',
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Icon(
                    Icons.person,
                    color: Color(0xFF0B5022),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 100),
            // زر المتابعة
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email.text);
                    Navigator.pushNamed(context, 'mlogin');
                  } on Exception catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('خطأ: ${e.toString()}')),
                    );
                  }

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) =>
                  //         OTPScreen())); // إضافة وظيفة الزر هنا
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green[800],
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'استمرار الدخول',
                  style: TextStyle(
                      fontSize: 22,
                      color: Color(0xFF0B5022),
                      fontFamily: "IBMPlexSansArabic",
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
