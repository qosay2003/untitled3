import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Usersingup extends StatelessWidget {
  const Usersingup({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();

    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController confirm_password = TextEditingController();
    Future<void> _signInWithGoogle(BuildContext context) async {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.additionalUserInfo!.isNewUser) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': userCredential.user!.displayName,
            'email': userCredential.user!.email,
            'role': 'user',
          });
        }

        Navigator.pushNamed(context, "homepage");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Error signing in with Google: ${e.toString()}',
            style: TextStyle(fontFamily: "IBMPlexSansArabic"),
          )),
        );
      }
    }

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
                          fontSize: 20,
                          fontFamily: "IBMPlexSansArabic" // حجم خط التسمية
                          ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: name,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: 'ادخل اسمك',
                        hintStyle: TextStyle(
                            fontSize: 20, fontFamily: "IBMPlexSansArabic"),
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
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "IBMPlexSansArabic"),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: email,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 16, fontFamily: "IBMPlexSansArabic"),
                      decoration: InputDecoration(
                        hintText: 'ادخل بريدك الالكتروني',
                        hintStyle: TextStyle(
                            fontSize: 20, fontFamily: "IBMPlexSansArabic"),
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
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "IBMPlexSansArabic"),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: password,
                      obscureText: true,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 16, fontFamily: "IBMPlexSansArabic"),
                      decoration: InputDecoration(
                        hintText: 'ادخل كلمة السر',
                        hintStyle: TextStyle(
                            fontSize: 16, fontFamily: "IBMPlexSansArabic"),
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
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: "IBMPlexSansArabic"),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: confirm_password,
                      obscureText: true,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 20, fontFamily: "IBMPlexSansArabic"),
                      decoration: InputDecoration(
                        hintText: 'ادخل كلمة السر مرة أخرى',
                        hintStyle: TextStyle(
                            fontSize: 16, fontFamily: "IBMPlexSansArabic"),
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
                    onPressed: () async {
                      if (password.text == confirm_password.text) {
                        try {
                          UserCredential user = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email.text, password: password.text);
                          user.user!.updateDisplayName(name.text);
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.user!.uid)
                              .set({
                            'name': name.text,
                            'email': email.text,
                            'role': 'user',
                          });

                          Navigator.pushNamed(context, "homepage");
                        } on Exception catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('خطأ: ${e.toString()}')),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'دخول',
                      style: TextStyle(
                          color: Color(0xFF0B5022),
                          fontSize: 24,
                          fontFamily: "IBMPlexSansArabic"),
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
                    fontWeight: FontWeight.bold,
                    fontFamily: "IBMPlexSansArabic"),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _signInWithGoogle(context),
                    child: FaIcon(FontAwesomeIcons.google,
                        color: Colors.white, size: 30),
                  ),
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
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontFamily: "IBMPlexSansArabic")),
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
