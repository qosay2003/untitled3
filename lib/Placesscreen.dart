import 'package:flutter/material.dart';

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
    {'name': 'الكل', 'image': 'img/my.jpeg'},
    {'name': 'سياحة', 'image': 'img/my.jpeg'},
    {'name': 'ترفيه', 'image': 'img/my.jpeg'},
    {'name': 'النوادي', 'image': 'img/my.jpeg'},
    {'name': 'مالية', 'image': 'img/my.jpeg'},
    {'name': 'مالية', 'image': 'img/my.jpeg'},
    {'name': 'مالية', 'image': 'img/my.jpeg'},
  ];

  // قائمة الأماكن (بيانات وهمية) مع إضافة حقل الصورة
  final List<Map<String, String>> places = [
    {
      'name': 'نادي فتنس تايم',
      'category': 'النوادي',
      'rating': '5',
      'image': 'img/my.jpeg'
    },
    {
      'name': 'الأهرامات',
      'category': 'سياحة',
      'rating': '4',
      'image': 'img/my.jpeg'
    },
    {
      'name': 'الفيروز',
      'category': 'ترفيه',
      'rating': '5',
      'image': 'img/my.jpeg'
    },
  ];

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
                      leading: null,
                      title: Row(
                        children: [
                          // إضافة الصورة داخل Card
                          Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.only(right: 10),
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
