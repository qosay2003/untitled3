import 'package:flutter/material.dart';

class GymProfileViewScreen extends StatelessWidget {
  final TextEditingController cityController;
  final TextEditingController areaController;
  final TextEditingController allweekdayHoursController;
  final TextEditingController priceMonthController;
  final TextEditingController price3MonthsController;
  final TextEditingController priceYearController;

  const GymProfileViewScreen({
    super.key,
    required this.cityController,
    required this.areaController,
    required this.allweekdayHoursController,
    required this.priceMonthController,
    required this.price3MonthsController,
    required this.priceYearController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFAAAAAA),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFAAAAAA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 10),
              // صورة النادي
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'img/my.jpeg',
                  height: 400,
                  width: 400,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              // اسم النادي
              Text(
                'نادي الوحدة لكمال اللأجسام',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              // أيقونات القلب والتعليق
              Container(
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite, color: Color(0xFF0B5022)),
                      onPressed: () {},
                    ),
                    SizedBox(width: 60),
                    IconButton(
                      icon: Icon(Icons.chat_bubble, color: Color(0xFF0B5022)),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              // الصندوق الرئيسي
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    sectionTitle("الموقع"),
                    buildDisplayField("المدينة", cityController.text),
                    buildDisplayField("المنطقة", areaController.text),
                    sectionTitle("ساعات العمل"),
                    buildDisplayField("", allweekdayHoursController.text),
                    sectionTitle("المرافق والخدمات"),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        "1. صالة حديد متكاملة بأحدث الأجهزة",
                        "2. مدربين شخصيين معتمدين",
                        "3. صالة كارديو منفصلة",
                        "4. مسبح داخلي وساونا",
                        "5. قاعة لياقة بدنية (زومبا، كروس فت، يوجا)",
                        "6. نظام اشتراكات شهرية وخصومات للطلاب",
                      ]
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                e,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    sectionTitle("أسعار الاشتراكات"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        subscriptionBox(
                            "سنة", priceYearController.text, Colors.purple),
                        subscriptionBox("3 أشهر", price3MonthsController.text,
                            Colors.black87),
                        subscriptionBox(
                            "شهر", priceMonthController.text, Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  Widget buildDisplayField(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          value.isEmpty ? label : value,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget subscriptionBox(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SizedBox(
            width: 70,
            child: Text(
              value.isEmpty ? "JD" : value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
