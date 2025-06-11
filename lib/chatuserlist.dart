import 'package:flutter/material.dart';
import 'package:untitled3/chats.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  // قائمة المستخدمين (بديل مؤقت لقاعدة البيانات)
  final List<Map<String, dynamic>> users = const [
    {
      'name': ' قصي الجعبري ',
      'image': 'img/logo.png',
      'unreadCount': '2', // عدد الرسائل غير المقروءة
    },
    {
      'name': '  براء ',
      'image': 'img/logo.png',
      'unreadCount': '2', // عدد الرسائل غير المقروءة
    },
    {
      'name': '  يزن ',
      'image': 'img/logo.png',
      'unreadCount': '2', // عدد الرسائل غير المقروءة
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFAAAAAA),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Text(
                'المحادثات',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "IBMPlexSansArabic",
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ]),
      backgroundColor: Color(0xFFAAAAAA),
      body: SafeArea(
        child: Stack(
          children: [
            // شعار التطبيق في الخلفية
            Center(
              child: Image.asset(
                'img/greenlogo.png',
                width: 400, // يمكن تعديل الحجم حسب الحاجة
                height: 400,
                fit: BoxFit.contain,
                opacity: AlwaysStoppedAnimation(0.6), // شفافية لتجنب التشتيت
              ),
            ),
            // قائمة المحادثات فوق الشعار
            ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  color: Color(0xFFAAAAAA),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userName: user['name']!,
                            userImage: user['image']!,
                          ),
                        ),
                      );
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 10),
                        Text(
                          user['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF0B5022),
                            fontFamily: "IBMPlexSansArabic",
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(user['image']!),
                        ),
                      ],
                    ),
                    leading: user['unreadCount'] != '0'
                        ? Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Color(0xFF0B5022),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                user['unreadCount']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "IBMPlexSansArabic",
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
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
