import 'package:flutter/material.dart';
class THiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 200,
                width: 500,
                child: Image.asset(
                  'img/hi3.png', // ضع هنا مسار الصورة (Path of the image)
                  fit: BoxFit.fill,


                ),
              ),
            ),
            Expanded(
                flex: 1,
                child:Container(
                  child: Padding(
                    padding:  EdgeInsets.all(20),
                    child: Text(
                      '!تواصل مع اخصائيي تغذية و مدربين شخصيين محترفين',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "IBMPlexSansArabic",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )

            ),

            Padding(
              padding: const EdgeInsets.all(40),
              child: ElevatedButton(

                onPressed: () {
                  Navigator.pushNamed(context,'mlogin' ); // الانتقال عند الضغط على الزر
                },

                style: ElevatedButton.styleFrom(

                  backgroundColor: Color(0xFF0B5022), // لون الزر الأخضر
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 45), // جعل الزر بعرض الشاشة
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'متابعة',
                  style: TextStyle(fontSize: 18,fontFamily: "IBMPlexSansArabic",fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}