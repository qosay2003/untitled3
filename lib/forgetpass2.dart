import 'package:flutter/material.dart';
import 'package:untitled3/forgetpass3.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  int _secondsRemaining = 59; // العداد الزمني
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
        _startTimer();
      } else {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF0B5022),
          iconTheme: IconThemeData(
            color: Colors.white,
          )),
      backgroundColor: Color(0xFF0B5022), // اللون الأخضر الداكن من الصورة
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: <Widget>[
                    // مكان صورة الشعار
                    Container(
                      child: Image.asset(
                        'img/logo.png', // مسار صورة الشعار
                        height: 300,
                        width: 300, // تعديل الحجم حسب الحاجة
                      ),
                    ),

                    // العنوان "التفعيل"
                    Text(
                      'التحقق من الحساب ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: "IBMPlexSansArabic",
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 16),
                    // النص التوضيحي
                    Text(
                      'لقد أرسلنا لك الكود على الإيميل email@gmail.com\nأدخل رمز التفعيل هنا',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 30),
                    // حقول إدخال رمز التفعيل
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: TextStyle(
                                  color: Color(0xFF0B5022), fontSize: 20),
                              decoration: InputDecoration(
                                counterText: '', // إخفاء عداد الأحرف
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 30),
                    // العداد الزمني
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: _canResend
                                ? () {
                                    setState(() {
                                      _secondsRemaining = 59;
                                      _canResend = false;
                                      _startTimer();
                                    });
                                  }
                                : null,
                            child: Text('اعادة إرسال الرمز',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 174, 216, 6),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "IBMPlexSansArabic",
                                ))),
                        Text(' لم تستلم الرمز ؟',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "IBMPlexSansArabic",
                            )),
                      ],
                    ),
                    Text(
                      'أعد الإرسال بعد $_secondsRemaining ثانية',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                // زر إعادة الإرسال
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => forgetpass3()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF1A3C34),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'التحقق من الحساب ',
                    style: TextStyle(
                      color: Color(0xFF0B5022),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "IBMPlexSansArabic",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
