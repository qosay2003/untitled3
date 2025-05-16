import 'package:flutter/material.dart';

class MainLogin1 extends StatefulWidget {
  const MainLogin1({super.key});

  @override
  State<MainLogin1> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<MainLogin1> with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // إعداد AnimationController
    _controller = AnimationController(
      duration: Duration(seconds: 2), // مدة الأنيميشن (2 ثانية)
      vsync: this,
    );
    // إعداد الأنيميشن للتحرك من خارج الشاشة إلى الموضع النهائي
    _animation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    // تشغيل الأنيميشن عند فتح الصفحة
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية الخضراء
          Container(
            color: Color(0xFF0B5022), // لون الخلفية الأخضر
          ),
          // الجزء الأبيض العلوي مع الأنيميشن
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                top: _animation.value, // تحريك الجزء الأبيض عموديًا
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2, // ارتفاع الجزء الأبيض
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
                        width: 150, // يمكنك تعديل العرض حسب الحاجة
                        height: 150, // يمكنك تعديل الارتفاع حسب الحاجة
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // نموذج تسجيل الدخول
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100), // مسافة لتجنب التداخل مع اللوغو
                  // حقل البريد الإلكتروني
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                      hintText: 'Email@gmail.com',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // حقل كلمة المرور
                  TextField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      hintText: '••••••••',
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
                      onPressed: () {},
                      child: Text(
                        'نسيت كلمة السر؟',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // زر الدخول
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'دخول',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 16),
                  // نص التسجيل
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ليس لديك حساب؟ ',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'اشترك الآن',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}