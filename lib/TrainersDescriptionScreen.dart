import 'package:flutter/material.dart';
import 'package:untitled3/manageSubscribers.dart';

class GymProfileScreen extends StatefulWidget {
  const GymProfileScreen({super.key});

  @override
  State<GymProfileScreen> createState() => _GymProfileScreenState();
}

class _GymProfileScreenState extends State<GymProfileScreen> {
  final cityController = TextEditingController();
  final areaController = TextEditingController();
  final allweekdayHoursController = TextEditingController();
  final priceMonthController = TextEditingController();
  final price3MonthsController = TextEditingController();
  final priceYearController = TextEditingController();

  // قائمة لتخزين controllers للمرافق والخدمات
  final List<TextEditingController> facilitiesControllers = [
    TextEditingController(text: "صالة حديد متكاملة بأحدث الأجهزة"),
    TextEditingController(text: "مدربين شخصيين معتمدين"),
    TextEditingController(text: "صالة كارديو منفصلة"),
    TextEditingController(text: "مسبح داخلي وساونا"),
    TextEditingController(text: "قاعة لياقة بدنية (زومبا، كروس فت، يوجا)"),
    TextEditingController(text: "نظام اشتراكات شهرية وخصومات للطلاب"),
  ];

  @override
  void dispose() {
    // تنظيف الـ controllers عند إغلاق الصفحة
    cityController.dispose();
    areaController.dispose();
    allweekdayHoursController.dispose();
    priceMonthController.dispose();
    price3MonthsController.dispose();
    priceYearController.dispose();
    for (var controller in facilitiesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // دالة لإضافة عنصر جديد للمرافق والخدمات
  void addFacility() {
    setState(() {
      facilitiesControllers.add(TextEditingController());
    });
  }

  // دالة لإزالة عنصر من المرافق والخدمات
  void removeFacility(int index) {
    setState(() {
      facilitiesControllers[index].dispose();
      facilitiesControllers.removeAt(index);
    });
  }

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
                  'img/logo.png',
                  height: 400,
                  width: 400,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              // اسم النادي داخل زخرفة
              Text(
                'نادي الوحدة لكمال اللأجسام',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "IBMPlexSansArabic",
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
                    buildInput("المدينة", cityController),
                    buildInput("المنطقة", areaController),
                    sectionTitle("ساعات العمل"),
                    buildInput("", allweekdayHoursController),
                    sectionTitle("المرافق والخدمات"),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // عرض حقول المرافق والخدمات القابلة للتعديل
                        ...facilitiesControllers.asMap().entries.map((entry) {
                          int index = entry.key;
                          TextEditingController controller = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => removeFacility(index),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: controller,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(fontSize: 17),
                                    decoration: InputDecoration(
                                      hintText: "أدخل الخدمة ${index + 1}",
                                      hintStyle: TextStyle(
                                        fontSize: 17,
                                        fontFamily: "IBMPlexSansArabic",
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        // زر إضافة خدمة جديدة
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextButton.icon(
                            onPressed: addFacility,
                            icon: Icon(Icons.add, color: Color(0xFF0B5022)),
                            label: Text(
                              "إضافة خدمة",
                              style: TextStyle(
                                color: Color(0xFF0B5022),
                                fontSize: 16,
                                fontFamily: "IBMPlexSansArabic",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    sectionTitle("أسعار الاشتراكات"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        subscriptionBox(
                            "سنة", priceYearController, Colors.purple),
                        subscriptionBox(
                            "3 أشهر", price3MonthsController, Colors.black87),
                        subscriptionBox(
                            "شهر", priceMonthController, Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
              // زر حفظ المعلومات
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // هنا يمكنك إضافة الكود لإرسال البيانات إلى قاعدة البيانات
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0B5022),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'حفظ المعلومات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "IBMPlexSansArabic",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10), // Separator between buttons
              // زر إلغاء
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Managesubscribers()));
                    // لا يقوم بأي إجراء (كما طلب)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0B5022),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'ادارة الاشترااكات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "IBMPlexSansArabic",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
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

  Widget buildInput(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget subscriptionBox(
    String label,
    TextEditingController controller,
    Color color,
  ) {
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
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "JD",
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: "IBMPlexSansArabic",
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// الشكل المزخرف
class NameBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey[300]!;

    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(size.width / 2, 60, size.width, 0)
      ..lineTo(size.width, 30)
      ..quadraticBezierTo(size.width / 2, 90, 0, 30)
      ..close();

    canvas.drawShadow(path, Colors.black45, 4, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
