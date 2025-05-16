import 'package:flutter/material.dart';
import 'package:untitled3/Placesscreen.dart';
import 'package:untitled3/calculatorscreenAI.dart';
import 'package:untitled3/forgetpass3.dart';
import 'package:untitled3/healthypage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List club = [
    {
      'image': 'img/damble.png',
      "text": "اكاديمية البر الرياضيه",
      "icon": Icons.star,
      "rating": 4 // عدد النجوم المملوءة
    },
    {
      'image': 'img/damble.png',
      "text": "اكاديمية البر الرياضيه",
      "icon": Icons.star,
      "rating": 3
    },
    {
      'image': 'img/damble.png',
      "text": "اكاديمية البر الرياضيه",
      "icon": Icons.star,
      "rating": 5
    },
    {
      'image': 'img/damble.png',
      "text": "اكاديمية البر الرياضيه",
      "icon": Icons.star,
      "rating": 2
    },
  ];

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
                SizedBox(width: 4),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: Color(0xFF0B5022),
                    size: 30,
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
                  "احمد محسن",
                  style: TextStyle(
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
                child: Image.asset(
                  "img/my.jpeg",
                  fit: BoxFit.cover,
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
                              'أحمد محسن',
                              style: TextStyle(
                                color: Color(0xFF0B5022),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              'ahmed@example.com',
                              style: TextStyle(
                                color: Color(0xFF0B5022),
                                fontSize: 14,
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
                              child: Image.asset(
                                "img/my.jpeg",
                                fit: BoxFit.cover,
                              )),
                        ),
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
                ),
                onTap: () {},
              ),
              ListTile(
                trailing: Icon(
                  Icons.password,
                  color: Color(0xFF0B5022),
                ),
                title: Text(
                  'تغيير كلمه السر',
                  textAlign: TextAlign.end,
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
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                trailing: Icon(
                  Icons.settings,
                  color: Color(0xFF0B5022),
                ),
                title: Text(
                  'الإعدادات',
                  textAlign: TextAlign.end,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
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
                          builder: (context) => CalorieCalculatorScreen()));
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
                              PlacesScreen(mainTitle: 'أكاديميات السباحة')));
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
                          builder: (context) =>
                              PlacesScreen(mainTitle: 'نوادي كمال الأجسام')));
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
                          builder: (context) =>
                              PlacesScreen(mainTitle: 'أكاديميات كرة القدم')));
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
                        print("تم النقر على الزر");
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
                itemCount: club.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        title: Image.asset(
                          club[index]['image'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        subtitle: Column(
                          children: [
                            Text(
                              club[index]['text'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B5022),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  5,
                                  (i) => Icon(
                                        Icons.star,
                                        size: 20,
                                        color: i < club[index]['rating']
                                            ? Color(0xFF0B5022)
                                            : Colors.white,
                                      )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        )));
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
            ),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
}
