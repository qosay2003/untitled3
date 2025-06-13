import 'package:flutter/material.dart';
import 'package:untitled3/TrainersDescriptionScreen.dart';
import 'package:untitled3/userTrainDes.dart';

class PlacesScreen extends StatefulWidget {
  final String mainTitle; // معلمة جديدة للعنوان الرئيسي

  const PlacesScreen(
      {super.key, required this.mainTitle}); // طلب المعلمة في المُنشئ

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  String selectedFilter = 'الكل'; // الفلتر المختار

  // قائمة الفلاتر مع الصور
  final List<Map<String, String>> filters = [
    {'name': 'الكل', 'image': 'img/greenlogo.png'},
    {'name': 'عمان', 'image': 'img/amman.jpg'},
    {'name': 'الزرقاء', 'image': 'img/zarqa.jpg'},
    {'name': 'البلقاء', 'image': 'img/blqaa.jpg'},
    {'name': 'مأدبا', 'image': 'img/madaba.jpg'},
    {'name': 'إربد', 'image': 'img/irbid.jpg'},
    {'name': 'المفرق', 'image': 'img/mafraq.jpg'},
    {'name': 'جرش', 'image': 'img/jerash.jpg'},
    {'name': 'عجلون', 'image': 'img/ajloon.jpg'},
    {'name': 'معان', 'image': 'img/maan.jpg'},
    {'name': 'العقبه', 'image': 'img/aqaba.jpg'},
    {'name': 'الكرك', 'image': 'img/karak.jpg'},
    {'name': 'الطفيلة', 'image': 'img/tafilah.jpg'},
  ];

  // قائمة الأماكن (بيانات وهمية) مع إضافة حقل الصورة
  final List<Map<String, String>> places = [
    {
      'name': 'نادي فتنس تايم',
      'category': 'عمان',
      'rating': '5',
      'image': 'img/logo.png'
    },
    {
      'name': 'الأهرامات',
      'category': 'زرقاء',
      'rating': '4',
      'image': 'img/logo.png'
    },
    {
      'name': 'الفيروز',
      'category': 'عمان',
      'rating': '5',
      'image': 'img/logo.png'
    },
  ];
  final TextEditingController cityController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController allweekdayHoursController =
      TextEditingController();
  final TextEditingController priceMonthController = TextEditingController();
  final TextEditingController price3MonthsController = TextEditingController();
  final TextEditingController priceYearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // فلترة الأماكن بناءً على الفلتر المختار
    List<Map<String, String>> filteredPlaces = selectedFilter == 'الكل'
        ? places
        : places.where((place) => place['category'] == selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              widget.mainTitle, // العنوان الرئيسي في الجهة اليمنى
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: "IBMPlexSansArabic",
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
        backgroundColor: Color(0xFF0B5022),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            // قائمة الفلاتر الدائرية
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filters[index]['name']!;
                        });
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                selectedFilter == filters[index]['name']
                                    ? Colors.green[300]
                                    : Colors.grey[300],
                            child: CircleAvatar(
                              radius: 28,
                              backgroundImage:
                                  AssetImage(filters[index]['image']!),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            filters[index]['name']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: selectedFilter == filters[index]['name']
                                  ? Colors.green[800]
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // قائمة الأماكن
            Expanded(
              child: ListView.builder(
                itemCount: filteredPlaces.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GymProfileViewScreen(
                                cityController: cityController,
                                areaController: areaController,
                                allweekdayHoursController:
                                    allweekdayHoursController,
                                priceMonthController: priceMonthController,
                                price3MonthsController: price3MonthsController,
                                priceYearController: priceYearController,
                                facilities: [])));
                      },
                      leading: null,
                      title: Row(
                        children: [
                          // إضافة الصورة داخل Card
                          Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.only(
                                left: 20), // تعديل المسافة إلى 20
                            child: Image.asset(
                              filteredPlaces[index]['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(filteredPlaces[index]['name']!),
                        ],
                      ),
                      subtitle: Text(
                          '${filteredPlaces[index]['category']} / القاهرة'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          int.parse(filteredPlaces[index]['rating']!),
                          (i) => const Icon(Icons.star,
                              color: Colors.grey, size: 20),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
