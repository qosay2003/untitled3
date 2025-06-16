import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/TrainersDescriptionScreen.dart';
import 'package:untitled3/userTrainDes.dart';

class PlacesScreen extends StatefulWidget {
  final String mainTitle;

  const PlacesScreen({super.key, required this.mainTitle});

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  String selectedFilter = 'الكل'; // Default filter is 'الكل'

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

  final TextEditingController cityController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController allweekdayHoursController =
      TextEditingController();
  final TextEditingController priceMonthController = TextEditingController();
  final TextEditingController price3MonthsController = TextEditingController();
  final TextEditingController priceYearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              widget.mainTitle,
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
            SizedBox(height: 30),
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
            Expanded(
              child: FutureBuilder(
                future: selectedFilter == 'الكل'
                    ? FirebaseFirestore.instance
                        .collection("sports_academies")
                        .where("type_of_sport", isEqualTo: widget.mainTitle)
                        .get()
                    : FirebaseFirestore.instance
                        .collection("sports_academies")
                        .where("type_of_sport", isEqualTo: widget.mainTitle)
                        .where("academy_city", isEqualTo: selectedFilter)
                        .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("حدث خطأ في جلب البيانات"));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("لا توجد أندية متاحة"));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var academy = snapshot.data!.docs[index];
                      Uint8List? bytes;

                      if (academy.data().containsKey("user_image") &&
                          academy['user_image'] != null &&
                          academy['user_image'].toString().isNotEmpty) {
                        try {
                          bytes = base64Decode(academy['user_image']);
                        } catch (e) {
                          bytes = null;
                        }
                      }

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
                                    price3MonthsController:
                                        price3MonthsController,
                                    priceYearController: priceYearController,
                                    facilities: [])));
                          },
                          leading: null,
                          title: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.only(left: 20),
                                child: bytes == null
                                    ? Image.asset('img/logo.png',
                                        fit: BoxFit.cover)
                                    : Image.memory(bytes, fit: BoxFit.cover),
                              ),
                              Text(academy["business_name"]),
                            ],
                          ),
                          subtitle: Text(academy["academy_city"]),
                        ),
                      );
                    },
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
