import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/mainlogin.dart';

// ignore: camel_case_types
class forgetpass3 extends StatelessWidget {
  const forgetpass3({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController password = TextEditingController();
    TextEditingController confirm_password = TextEditingController();
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
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  'img/logo.png', // ضع هنا مسار اللوغو (Path of the logo)
                  width: 200, // يمكنك تعديل العرض حسب الحاجة
                  height: 200, // يمكنك تعديل الارتفاع حسب الحاجة
                ),
              ),
            ),

            // النص الأول
            Expanded(
              flex: 1,
              child: Text(
                'إنشاء كلمة سر جديدة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: "IBMPlexSansArabic",
                ),
              ),
            ),
            // النص التوضيحي
            Expanded(
              flex: 1,
              child: Text(
                'يرجى كلمة المرور الجديدة و تأكيدها\n سوف تحتاج الى تسجيل الدخول بعد إعاده التعيين',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "IBMPlexSansArabic",
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    'كلمة المرور الجديدة',
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
            Expanded(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TextField(
                  controller: password,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'ادخل كلمة المرور',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: "IBMPlexSansArabic",
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    'تأكيد كلمة المرور ',
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

            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: TextField(
                  controller: confirm_password,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '  ادخل كلمه المرور مره اخرى',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: "IBMPlexSansArabic",
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            // زر المتابعة
            Center(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () {
                    if (password.text == confirm_password.text) {
                      try {
                        FirebaseAuth.instance.currentUser!
                            .updatePassword(password.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Password updated successfully')),
                        );
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => mainlogin()));
                      } on Exception catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                            'خطأ: ${e.toString()}',
                            style: TextStyle(
                              fontFamily: "IBMPlexSansArabic",
                            ),
                          )),
                        );
                      }
                    }
                    // إضافة وظيفة الزر هنا
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
            ),
          ],
        ),
      ),
    );
  }
}
