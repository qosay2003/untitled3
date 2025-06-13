import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/shopBhealthy.dart';
import 'package:untitled3/userTrainDes.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  final Color backgroundColor = const Color(0xFFAAAAAA);

  // Lists for dynamic items
  final List<Map<String, String>> nutritionists = [
    {'name': 'د. أحمد السعدي', 'image': 'img/logo.png'},
    {'name': 'د. فاطمة المطيري', 'image': 'img/logo.png'},
    // Add more nutritionists here as needed
  ];

  final List<Map<String, String>> trainers = [
    {'name': 'أحمد العلي', 'image': 'img/logo.png'},
    {'name': 'محمد الخليفة', 'image': 'img/logo.png'},
    {'name': 'أحمد العلي', 'image': 'img/logo.png'},
    {'name': 'محمد الخليفة', 'image': 'img/logo.png'},
    // Add more trainers here as needed
  ];

  // Initialize TextEditingControllers
  final TextEditingController cityController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController allweekdayHoursController =
      TextEditingController();
  final TextEditingController priceMonthController = TextEditingController();
  final TextEditingController price3MonthsController = TextEditingController();
  final TextEditingController priceYearController = TextEditingController();

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    cityController.dispose();
    areaController.dispose();
    allweekdayHoursController.dispose();
    priceMonthController.dispose();
    price3MonthsController.dispose();
    priceYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF0B5022),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: trasearch());
            },
          ),
          Text(
            "   متجر رياضي و أخصائيّو و مدربين",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "IBMPlexSansArabic",
            ),
          ),
          SizedBox(
            width: 40,
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            // Shop Section Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'متجر رياضي',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "IBMPlexSansArabic",
                ),
              ),
            ),
            // Shop Card
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Shopbhealthy()),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF0B5022),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 7),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HorizontalShopCard(
                      title: 'B healthy',
                      subtitle: 'جميع مستلزماتك الرياضية',
                      imagePath: 'img/greenlogo.png',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16), // Separator
            // Nutritionists Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'أخصائيّو التغذية',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "IBMPlexSansArabic",
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("business_type", isEqualTo: "  اخصائي تغذيه")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return Container(
                  height: 150,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      Uint8List bytes = base64Decode(
                          snapshot.data!.docs[index]['image_data']);
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        width: 150,
                        child: Card(
                          color: Colors.grey,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GymProfileViewScreen(
                                    cityController: cityController,
                                    areaController: areaController,
                                    allweekdayHoursController:
                                        allweekdayHoursController,
                                    priceMonthController: priceMonthController,
                                    price3MonthsController:
                                        price3MonthsController,
                                    priceYearController: priceYearController,
                                    facilities: [], // Pass an empty list for now
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: MemoryImage(bytes),
                                  backgroundColor: Colors.grey[200],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  snapshot.data!.docs[index]['business_name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0B5022),
                                    fontFamily: "IBMPlexSansArabic",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 16), // Separator
            // Trainers Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'مدربين شخصيين',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "IBMPlexSansArabic",
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("business_type", isEqualTo: " مدرب رياضي")
                  .snapshots(),
              builder: (context, snapshot) {
                return Container(
                  height: 150,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      Uint8List bytes = base64Decode(
                          snapshot.data!.docs[index]['image_data']);
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        width: 150,
                        child: Card(
                          color: Colors.grey,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GymProfileViewScreen(
                                    cityController: cityController,
                                    areaController: areaController,
                                    allweekdayHoursController:
                                        allweekdayHoursController,
                                    priceMonthController: priceMonthController,
                                    price3MonthsController:
                                        price3MonthsController,
                                    priceYearController: priceYearController,
                                    facilities: [],
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      MemoryImage(bytes),
                                  backgroundColor: Colors.grey[200],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  snapshot.data!.docs[index]['business_name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0B5022),
                                    fontFamily: "IBMPlexSansArabic",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalShopCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const HorizontalShopCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(imagePath),
            backgroundColor: Colors.grey[200],
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: "IBMPlexSansArabic",
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontFamily: "IBMPlexSansArabic",
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class NutritionistCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final VoidCallback onTap;

  const NutritionistCard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(imagePath),
              backgroundColor: Colors.grey[200],
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: "IBMPlexSansArabic",
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class TrainerCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final VoidCallback onTap;

  const TrainerCard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(imagePath),
              backgroundColor: Colors.grey[200],
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: "IBMPlexSansArabic",
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder pages for navigation
class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'متاجر رياضية',
        style: TextStyle(
          fontFamily: "IBMPlexSansArabic",
        ),
      )),
      body: Center(
          child: Text(
        'صفحة المتاجر الرياضية',
        style: TextStyle(
          fontFamily: "IBMPlexSansArabic",
        ),
      )),
    );
  }
}

class NutritionistDetailPage extends StatelessWidget {
  const NutritionistDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'تفاصيل الأخصائي',
        style: TextStyle(
          fontFamily: "IBMPlexSansArabic",
        ),
      )),
      body: Center(
          child: Text(
        'صفحة تفاصيل الأخصائي',
        style: TextStyle(
          fontFamily: "IBMPlexSansArabic",
        ),
      )),
    );
  }
}

class TrainerDetailPage extends StatelessWidget {
  const TrainerDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'تفاصيل المدرب',
        style: TextStyle(
          fontFamily: "IBMPlexSansArabic",
        ),
      )),
      body: Center(
          child: Text(
        'صفحة تفاصيل المدرب',
        style: TextStyle(
          fontFamily: "IBMPlexSansArabic",
        ),
      )),
    );
  }
}

// ignore: camel_case_types
class trasearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // هنا يمكنك إضافة منطق عرض النتائج بناءً على الاستعلام
    return ListView(
      children: [
        ListTile(
          title: Text(
            'نتيجة 1: $query',
            style: TextStyle(
              fontFamily: "IBMPlexSansArabic",
            ),
          ),
          onTap: () {
            // تنفيذ الإجراء عند النقر على نتيجة معينة
          },
        ),
        ListTile(
          title: Text(
            'نتيجة 2: $query',
            style: TextStyle(
              fontFamily: "IBMPlexSansArabic",
            ),
          ),
          onTap: () {
            // تنفيذ الإجراء عند النقر على نتيجة معينة
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // هنا يمكنك إضافة منطق عرض الاقتراحات بناءً على الاستعلام
    return ListView(
      children: [
        ListTile(
          title: Text(
            'اقتراح 1: $query',
            style: TextStyle(
              fontFamily: "IBMPlexSansArabic",
            ),
          ),
          onTap: () {
            // تنفيذ الإجراء عند النقر على اقتراح معين
          },
        ),
        ListTile(
          title: Text(
            'اقتراح 2: $query',
            style: TextStyle(
              fontFamily: "IBMPlexSansArabic",
            ),
          ),
          onTap: () {
            // تنفيذ الإجراء عند النقر على اقتراح معين
          },
        ),
      ],
    );
  }
}
