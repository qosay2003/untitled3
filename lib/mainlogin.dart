import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/choosesingup.dart';
import 'package:untitled3/forgetpass1.dart';

class mainlogin extends StatefulWidget {
  const mainlogin({super.key});

  @override
  State<mainlogin> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<mainlogin> {
  bool _obscureText = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية الخضراء
          Container(
            color: Color(0xFF0B5022), // لون الخلفية الأخضر
          ),
          // الجزء الأبيض العلوي
          Positioned(
            top: 0,
            left: -80,
            right: -80,
            bottom: 550,
            child: Container(
              height: 1000,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(700),
                  bottomRight: Radius.circular(700),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Image.asset(
                    'img/greenlogo.png', // ضع هنا مسار اللوغو (Path of the logo)
                    width: 300, // يمكنك تعديل العرض حسب الحاجة
                    height: 300, // يمكنك تعديل الارتفاع حسب الحاجة
                  ),
                ),
              ),
            ),
          ),
          // نموذج تسجيل الدخول
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 250), // مسافة لتجنب التداخل مع اللوغو
                    // حقل البريد الإلكتروني
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0xFF0B5022),
                        ),
                        hintText: 'Email@gmail.com',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: "IBMPlexSansArabic",
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    // حقل كلمة المرور
                    TextField(
                      controller: password,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF0B5022)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFF0B5022),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        hintText: '********',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: "IBMPlexSansArabic",
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => forgetpass1()));
                        },
                        child: Text(
                          'نسيت كلمة السر؟',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "IBMPlexSansArabic",
                              fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                    // زر الدخول
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email.text.trim(),
                            password: password.text.trim(),
                          );
                          Navigator.pushNamed(context, "homepage");
                        } on FirebaseAuthException catch (e) {
                          String errorMessage;
                          if (e.code == 'user-not-found') {
                            errorMessage = 'البريد الإلكتروني غير مسجل';
                          } else if (e.code == 'wrong-password') {
                            errorMessage = 'كلمة المرور غير صحيحة';
                          } else if (e.code == 'invalid-email') {
                            errorMessage = 'البريد الإلكتروني غير صالح';
                          } else {
                            errorMessage = 'حدث خطأ أثناء تسجيل الدخول';
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                errorMessage,
                                style:
                                    TextStyle(fontFamily: "IBMPlexSansArabic"),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'حدث خطأ غير متوقع',
                                style:
                                    TextStyle(fontFamily: "IBMPlexSansArabic"),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'دخول',
                        style: TextStyle(
                            fontFamily: "IBMPlexSansArabic",
                            fontSize: 18,
                            color: Color(0xFF0B5022)),
                      ),
                    ),
                    SizedBox(height: 16),
                    // نص التسجيل
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => choosesingup()));
                          },
                          child: Text(
                            'اشترك الآن',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "IBMPlexSansArabic",
                                fontSize: 18),
                          ),
                        ),
                        Text('ليس لديك حساب؟ ',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "IBMPlexSansArabic",
                                fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
