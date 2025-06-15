import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled3/ClubsandCoachesPage.dart';
import 'package:untitled3/Placesscreen.dart';
import 'package:untitled3/TrainersDescriptionScreen.dart';
import 'package:untitled3/calcbot.dart';
import 'package:untitled3/chatuserlist.dart';
import 'package:untitled3/forgetpass3.dart';
import 'package:untitled3/healthypage.dart';
import 'package:untitled3/subscribeUser.dart';
import 'package:untitled3/userTrainDes.dart';
import 'package:untitled3/chatAI.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  File? user_image;
  Future<void> pickImageSelectFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        setState(() {
          user_image = File(pickedFile.path);
        });

        await uploadData();
      }
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select image: ${e.toString()}')),
      );
    }
  }

  Future<void> pickImageSelectFromCamera() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        setState(() {
          user_image = File(pickedFile.path);
        });

        await uploadData();
      }
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture image: ${e.toString()}')),
      );
    }
  }

  Future<String> _imageToBase64(File imageFile) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      print("Error converting image: $e");
      throw Exception("Failed to convert image to base64");
    }
  }

  Future<void> uploadData() async {
    if (user_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      String base64Image = await _imageToBase64(user_image!);

      String userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        "user_image": base64Image,
        "last_updated": FieldValue.serverTimestamp(),
      });

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded successfully!')),
      );
    } catch (e) {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: ${e.toString()}')),
      );
    }
  }

  Future<Uint8List?> getUserImage() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        String? base64Image =
            (userDoc.data() as Map<String, dynamic>)['user_image'];
        if (base64Image != null && base64Image.isNotEmpty) {
          return base64Decode(base64Image);
        }
      }
      return null;
    } catch (e) {
      print("Error fetching user image: $e");
      return null;
    }
  }

  // قائمة افتراضية لعدد الرسائل غير المقروءة (بديل مؤقت لقاعدة البيانات)
  final List<Map<String, dynamic>> users = const [
    {'unreadCount': '2'},
    {'unreadCount': '0'},
    {'unreadCount': '5'},
  ];

  // حساب إجمالي عدد الرسائل غير المقروءة
  int get totalUnreadCount {
    return users.fold(0, (sum, user) => sum + int.parse(user['unreadCount']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFAAAAAA),
        appBar: AppBar(
          shadowColor: Color(0xFFAAAAAA),
          backgroundColor: Color(0xFFAAAAAA),
          leadingWidth: 200,
          leading: Builder(
            builder: (context) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    size: 20,
                    Icons.menu,
                    color: Color(0xFF0B5022),
                    shadows: [
                      Shadow(
                          color: Color(0xFF0B5022),
                          offset: Offset(2, 2),
                          blurRadius: 40)
                    ],
                  ),
                ),
                NotificationBell(),
                SizedBox(width: 4),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatListScreen()),
                        );
                      },
                      icon: Icon(
                        Icons.chat,
                        color: Color(0xFF0B5022),
                        size: 20,
                      ),
                    ),
                    if (totalUnreadCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Color(0xFF0B5022),
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            totalUnreadCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: "IBMPlexSansArabic",
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 4),
                IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: appsearch());
                  },
                  icon: Icon(
                    Icons.search,
                    color: Color(0xFF0B5022),
                    size: 20,
                    shadows: [
                      Shadow(
                          color: Color.fromARGB(255, 1, 23, 9),
                          offset: Offset.zero,
                          blurRadius: 40)
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  FirebaseAuth.instance.currentUser?.displayName.toString() ??
                      "user",
                  style: TextStyle(
                    fontFamily: "IBMPlexSansArabic",
                    shadows: [
                      Shadow(
                          color: Color(0xFF0B5022),
                          offset: Offset(3, 3),
                          blurRadius: 20)
                    ],
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B5022),
                    fontSize: 16,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            Container(width: 10),
            Container(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FutureBuilder<Uint8List?>(
                  future: getUserImage(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      );
                    } else {
                      return Image.asset(
                        "img/logo.png",
                        fit: BoxFit.cover,
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        'القائمة',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Color(0xFF0B5022),
                          fontSize: 24,
                          fontFamily: "IBMPlexSansArabic",
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              FirebaseAuth.instance.currentUser?.displayName
                                      .toString() ??
                                  "user",
                              style: TextStyle(
                                color: Color(0xFF0B5022),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "IBMPlexSansArabic",
                              ),
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              FirebaseAuth.instance.currentUser?.email ??
                                  "user@email.com",
                              style: TextStyle(
                                color: Color(0xFF0B5022),
                                fontSize: 14,
                                fontFamily: "IBMPlexSansArabic",
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: FutureBuilder<Uint8List?>(
                              future: getUserImage(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasData &&
                                    snapshot.data != null) {
                                  return Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  return Image.asset(
                                    "img/logo.png",
                                    fit: BoxFit.cover,
                                  );
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                trailing: Icon(
                  Icons.home,
                  color: Color(0xFF0B5022),
                ),
                title: Text(
                  'الرئيسية',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: "IBMPlexSansArabic",
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                trailing: Icon(
                  Icons.camera_alt,
                  color: Color(0xFF0B5022),
                ),
                title: Text(
                  'تغيير الصوره',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: "IBMPlexSansArabic",
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "اختيار طريقه تحميل الصوره ",
                          style: TextStyle(
                            fontFamily: "IBMPlexSansArabic",
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: pickImageSelectFromGallery,
                              child: Text(
                                "من المعرض",
                                style: TextStyle(
                                  fontFamily: "IBMPlexSansArabic",
                                ),
                              )),
                          TextButton(
                              onPressed: pickImageSelectFromCamera,
                              child: Text(
                                "بأستخدام الكاميرا",
                                style: TextStyle(
                                  fontFamily: "IBMPlexSansArabic",
                                ),
                              )),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                trailing: Icon(
                  Icons.password,
                  color: Color(0xFF0B5022),
                ),
                title: Text(
                  'تغيير كلمه السر',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: "IBMPlexSansArabic",
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => forgetpass3()));
                },
              ),
              ListTile(
                trailing: Icon(
                  Icons.edit,
                  color: Color(0xFF0B5022),
                ),
                title: Text(
                  'تغيير الاسم',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: "IBMPlexSansArabic",
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox();
                  }

                  if (snapshot.hasError) {
                    return Text("حدث خطأ");
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return SizedBox();
                  }

                  final userData = snapshot.data!;

                  final businessType =
                      userData.data()!.containsKey("business_type")
                          ? userData.get("business_type")
                          : null;

                  if (businessType != null) {
                    return ListTile(
                      trailing: Icon(
                        Icons.manage_accounts,
                        color: Color(0xFF0B5022),
                      ),
                      title: Text(
                        ' ادارة صفحتي',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontFamily: "IBMPlexSansArabic",
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GymProfileScreen()));
                      },
                    );
                  }

                  return ListTile(
                    trailing: Icon(
                      Icons.add_home_work_outlined,
                      color: Color(0xFF0B5022),
                    ),
                    title: Text(
                      '  إشتراكاتي ',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontFamily: "IBMPlexSansArabic",
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SubscriptionsScreen()));
                    },
                  );
                },
              ),
              ListTile(
                trailing: Icon(
                  Icons.logout,
                  color: Color(0xFF0B5022),
                ),
                title: Text(
                  '  تسجيل خروج ',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: "IBMPlexSansArabic",
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreenai()),
                );
              },
              backgroundColor: Color(0xFF0B5022),
              child: Text(
                "AI Chat",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "IBMPlexSansArabic",
                ),
              ),
            ),
            if (totalUnreadCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                ),
              ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("bestClubsOptions")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            // Handle errors
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'حدث خطأ في تحميل البيانات',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: "IBMPlexSansArabic",
                  ),
                ),
              );
            }

            // Handle empty data
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد بيانات متاحة',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "IBMPlexSansArabic",
                  ),
                ),
              );
            }
            final data = snapshot.data!.docs;

            return SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 16),
                        child: Text(
                          "معلوماتي",
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.black,
                              fontFamily: "IBMPlexSansArabic",
                              shadows: [
                                Shadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(1, 1))
                              ]),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CalorieCalculatorScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 20,
                            backgroundColor: Color(0xFFAAAAAA),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Image.asset(
                            "img/ai2.png",
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Healthypage()));
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 20,
                            backgroundColor: Color.fromRGBO(170, 170, 170, 1),
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Image.asset(
                            "img/ai1.png",
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            "احسب سعراتك ",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B5022),
                                fontFamily: "IBMPlexSansArabic",
                                shadows: [
                                  Shadow(
                                      color: Color(0xFF0B5022),
                                      blurRadius: 5,
                                      offset: Offset(1, 1))
                                ]),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            "تابع تطورك الصحي",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B5022),
                                fontFamily: "IBMPlexSansArabic",
                                shadows: [
                                  Shadow(
                                      color: Color(0xFF0B5022),
                                      blurRadius: 5,
                                      offset: Offset(1, 1))
                                ]),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    )
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 16),
                        child: Text(
                          "الأقسام الرئيسية",
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.black,
                              fontFamily: "IBMPlexSansArabic",
                              shadows: [
                                Shadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(1, 1))
                              ]),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PlacesScreen(
                                    mainTitle: 'أكاديميات السباحة')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD9D9D9),
                            elevation: 5,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Image.asset(
                            "img/bool.png",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PlacesScreen(
                                    mainTitle: 'نوادي كمال الأجسام')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD9D9D9),
                            elevation: 5,
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Image.asset(
                            "img/damble.png",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PlacesScreen(
                                    mainTitle: 'أكاديميات الفنون القتالية')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD9D9D9),
                            elevation: 5,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Image.asset(
                            "img/kill.png",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PlacesScreen(
                                    mainTitle: 'أكاديميات كرة القدم')));
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: Color(0xFFD9D9D9),
                            padding: EdgeInsets.all(-8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Image.asset(
                            "img/football.png",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      )
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            textAlign: TextAlign.center,
                            "أكاديميات سباحة ",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B5022),
                                fontFamily: "IBMPlexSansArabic",
                                shadows: [
                                  Shadow(
                                      color: Color(0xFF0B5022),
                                      blurRadius: 5,
                                      offset: Offset(1, 1))
                                ]),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            textAlign: TextAlign.center,
                            "نوادي كمال \nاجسام",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B5022),
                                fontFamily: "IBMPlexSansArabic",
                                shadows: [
                                  Shadow(
                                      color: Color(0xFF0B5022),
                                      blurRadius: 5,
                                      offset: Offset(1, 1))
                                ]),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            " أكاديميات فنون قتالية ",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B5022),
                                fontFamily: "IBMPlexSansArabic",
                                shadows: [
                                  Shadow(
                                      color: Color(0xFF0B5022),
                                      blurRadius: 5,
                                      offset: Offset(1, 1))
                                ]),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            "أكاديميات \n كرةالقدم",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B5022),
                                fontFamily: "IBMPlexSansArabic",
                                shadows: [
                                  Shadow(
                                      color: Color(0xFF0B5022),
                                      blurRadius: 5,
                                      offset: Offset(1, 1))
                                ]),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    )
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ShopsScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              backgroundColor: Color.fromRGBO(170, 170, 170, 1),
                              padding: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Image.asset(
                              "img/buttonhome.png",
                              width: 400,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors.red,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 16),
                        child: Text(
                          "افضل الخيارات",
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.black,
                              fontFamily: "IBMPlexSansArabic",
                              shadows: [
                                Shadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(1, 1))
                              ]),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        try {
                          Uint8List bytes =
                              base64Decode(data[index]["club_image"]);
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            width: 180,
                            height: 100,
                            child: Card(
                              color: Colors.grey,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                onTap: () {},
                                title: Image.memory(
                                  bytes,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                                subtitle: Column(
                                  children: [
                                    Text(
                                      data[index]["club_name"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0B5022),
                                        fontFamily: "IBMPlexSansArabic",
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                          5,
                                          (i) => Icon(
                                                Icons.star,
                                                size: 20,
                                                color: i <
                                                        data[index]
                                                            ["club_evaluation"]
                                                    ? Color(0xFF0B5022)
                                                    : Colors.white,
                                              )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } catch (e) {
                          return Container(
                            width: 180,
                            child: Card(
                              child: Center(
                                child: Text(
                                  "خطأ في تحميل البيانات",
                                  style: TextStyle(
                                    fontFamily: "IBMPlexSansArabic",
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
}

class NotificationBell extends StatefulWidget {
  @override
  _NotificationBellState createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  bool _isNotificationActive = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        size: 20,
        Icons.notifications,
        color: _isNotificationActive ? Color(0xFF0B5022) : Colors.white,
      ),
      onPressed: () {
        setState(() {
          _isNotificationActive = !_isNotificationActive;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isNotificationActive
                  ? 'تم تفعيل الإشعارات'
                  : 'تم إلغاء تفعيل الإشعارات',
              style: TextStyle(
                fontFamily: "IBMPlexSansArabic",
              ),
            ),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
}

class appsearch extends SearchDelegate {
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
