import 'package:flutter/material.dart';

class Bissingup extends StatelessWidget {
  final Color backgroundColor = Color(0xFF0C552E);

  Bissingup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: AppBar(
                centerTitle: true,
                title: Text('sign up',
                    style: TextStyle(
                      color: Color(0xFF0B5022),
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                      fontFamily: "IBMPlexSansArabic",
                    )),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    buildField('اسم العمل', 'أدخل اسم العمل'),
                    buildField('البريد الإلكتروني',
                        'أدخل البريد الإلكتروني الخاص بالعمل'),
                    Row(
                      children: [
                        Expanded(
                          child: buildFieldWithIcon(
                              'موقع العمل', 'مدينة الإقامة', Icons.location_on),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: buildDropdownWithIcons('نوع العمل', [
                            {
                              'label': 'كمال الاجسام',
                              'image': 'img/damble.png',
                            },
                            {
                              'label': 'اكاديمية كره',
                              'image': 'img/football.png',
                            },
                            {
                              'label': 'مسبح',
                              'image': 'img/bool.png',
                            },
                            {
                              'label': 'فنون قتاليه',
                              'image': 'img/kill.png',
                            },
                          ]),
                        ),
                      ],
                    ),
                    buildDropdown('الجنس', ['ذكر', 'أنثى']),
                    buildImagePicker('صورة الهوية المدنية',
                        'أرفع صورة عن الهوية المدنية من الأدام'),
                    buildFieldWithIcon(
                        'كلمة السر', 'أدخل كلمة السر', Icons.lock,
                        obscure: true),
                    buildField('تأكيد كلمة السر', 'أدخل كلمة السر مرة أخرى',
                        obscure: true),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD8E4D3),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'إنشاء الحساب',
                          style:
                              TextStyle(color: backgroundColor, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField(String label, String hint, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 5),
          TextField(
            obscureText: obscure,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
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
    );
  }

  Widget buildFieldWithIcon(String label, String hint, IconData icon,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 5),
          TextField(
            obscureText: obscure,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 16),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(icon),
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
    );
  }

  Widget buildDropdownWithIcons(
      String label, List<Map<String, dynamic>> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            hint: Text('اختر $label', textDirection: TextDirection.rtl),
            items: items.map((Map<String, dynamic> item) {
              return DropdownMenuItem<String>(
                value: item['label'],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(item['label'], textDirection: TextDirection.rtl),
                    SizedBox(width: 10),
                    Image.asset(
                      item['image'],
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            hint: Text('اختر $label', textDirection: TextDirection.rtl),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, textDirection: TextDirection.rtl),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }

  Widget buildImagePicker(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 5),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt, color: backgroundColor),
                  onPressed: () {},
                ),
                Expanded(
                  child: Text(
                    hint,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
