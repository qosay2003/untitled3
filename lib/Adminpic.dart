import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestReview extends StatefulWidget {
  const RequestReview({super.key});

  @override
  State<RequestReview> createState() => _RequestReviewState();
}

class _RequestReviewState extends State<RequestReview> {
  final Color backgroundColor = const Color(0xFF0C552E);

  Future<void> _updateRequestStatus(String userId, String status) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'status': status,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم تحديث حالة الطلب إلى: $status',
            style: const TextStyle(fontFamily: "IBMPlexSansArabic"),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء تحديث الحالة: $e',
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
          'مراجعة الطلبات',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                'لا توجد طلبات لعرضها',
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
              var userData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              var userId = snapshot.data!.docs[index].id;
              var idPhotoBase64 = userData['id_photo'] as String?;
              var workPhotoBase64 = userData['work_practice_image'] as String?;

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'صورة الهوية المدنية',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "IBMPlexSansArabic",
                        ),
                      ),
                      const SizedBox(height: 10),
                      idPhotoBase64 != null
                          ? Image.memory(
                              base64Decode(idPhotoBase64),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Text(
                                'خطأ في تحميل صورة الهوية',
                                style:
                                    TextStyle(fontFamily: "IBMPlexSansArabic"),
                              ),
                            )
                          : const Text(
                              'لم يتم رفع صورة الهوية',
                              style: TextStyle(fontFamily: "IBMPlexSansArabic"),
                            ),
                      const SizedBox(height: 20),
                      const Text(
                        'صورة مزاولة العمل',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "IBMPlexSansArabic",
                        ),
                      ),
                      const SizedBox(height: 10),
                      workPhotoBase64 != null
                          ? Image.memory(
                              base64Decode(workPhotoBase64),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Text(
                                'خطأ في تحميل صورة مزاولة العمل',
                                style:
                                    TextStyle(fontFamily: "IBMPlexSansArabic"),
                              ),
                            )
                          : const Text(
                              'لم يتم رفع صورة مزاولة العمل',
                              style: TextStyle(fontFamily: "IBMPlexSansArabic"),
                            ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                _updateRequestStatus(userId, 'مقبول'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD8E4D3),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'قبول الطلب',
                              style: TextStyle(
                                color: Color(0xFF0C552E),
                                fontSize: 16,
                                fontFamily: "IBMPlexSansArabic",
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                _updateRequestStatus(userId, 'مرفوض'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[100],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'رفض الطلب',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontFamily: "IBMPlexSansArabic",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
