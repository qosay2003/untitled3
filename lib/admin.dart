import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/Adminpic.dart';

class TrainerCards extends StatefulWidget {
  const TrainerCards({super.key});

  @override
  State<TrainerCards> createState() => _TrainerCardsState();
}

class _TrainerCardsState extends State<TrainerCards> {
  final Color backgroundColor = const Color(0xFF0C552E);

  Future<void> _deleteUserData(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم حذف البيانات بنجاح',
            style: TextStyle(fontFamily: "IBMPlexSansArabic"),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء الحذف: $e',
            style: const TextStyle(fontFamily: "IBMPlexSansArabic"),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'بيانات المدربين',
          style: TextStyle(
            color: Color(0xFF0B5022),
            fontWeight: FontWeight.w900,
            fontSize: 40,
            fontFamily: "IBMPlexSansArabic",
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'حدث خطأ أثناء جلب البيانات',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "IBMPlexSansArabic",
                        fontSize: 18,
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا توجد بيانات لعرضها',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "IBMPlexSansArabic",
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var userData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    var userId = snapshot.data!.docs[index].id;

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildInfoRow('اسم العمل',
                                      userData['business_name'] ?? 'غير متوفر'),
                                  _buildInfoRow('البريد الإلكتروني',
                                      userData['email'] ?? 'غير متوفر'),
                                  _buildInfoRow('نوع العمل',
                                      userData['business_type'] ?? 'غير متوفر'),
                                  _buildInfoRow(
                                      'موقع العمل',
                                      userData['city_of_residence'] ??
                                          'غير متوفر'),
                                  _buildInfoRow('الجنس',
                                      userData['gender'] ?? 'غير متوفر'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUserData(userId),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RequestReview(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD8E4D3),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'طلبات الصور',
                  style: TextStyle(
                    color: Color(0xFF0C552E),
                    fontSize: 18,
                    fontFamily: "IBMPlexSansArabic",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: "IBMPlexSansArabic",
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: "IBMPlexSansArabic",
            ),
          ),
        ],
      ),
    );
  }
}
