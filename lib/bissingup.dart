import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Bissingup extends StatefulWidget {
  Bissingup({super.key});

  @override
  State<Bissingup> createState() => _BissingupState();
}

class _BissingupState extends State<Bissingup> {
  final Color backgroundColor = Color(0xFF0C552E);
  String? selected_item;
  String? selectedCity;

  String? gender;
  File? idImage;

  TextEditingController business_name = TextEditingController();

  TextEditingController email = TextEditingController();
  TextEditingController city_of_residence = TextEditingController();

  TextEditingController password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();
  final List<String> jordanCities = [
    'عمان',
    'الزرقاء',
    'إربد',
    'البلقاء',
    'مادبا',
    'الكرك',
    'الطفيلة',
    'معان',
    'العقبة',
    'جرش',
    'عجلون',
    'المفرق'
  ];

  Future<void> pickImageSelectFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        idImage = File(pickedFile.path);
      });
    }
    Navigator.of(context).pop();
  }

  Future<void> pickImageSelectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        idImage = File(pickedFile.path);
      });
    }
    Navigator.of(context).pop();
  }

  Future<String?> _imageToBase64(File imageFile) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      return base64Image;
    } catch (e) {
      print("Error converting image: $e");
      return null;
    }
  }

  Future<void> uploadData() async {
    if (idImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          'الرجاء اختيار صورة الهوية',
          style: TextStyle(fontFamily: "IBMPlexSansArabic"),
        )),
      );
      return;
    }

    try {
      String? base64Image = await _imageToBase64(idImage!);

      if (base64Image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'حدث خطأ في معالجة الصورة',
            style: TextStyle(
              fontFamily: "IBMPlexSansArabic",
            ),
          )),
        );
        return;
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      await userCredential.user!.updateDisplayName(business_name.text);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "id_photo": base64Image,
        "business_name": business_name.text,
        "email": email.text,
        "city_of_residence": selectedCity,
        "gender": gender,
        "business_type": selected_item,
        "user_id": userCredential.user!.uid,
        'role': 'user',
      });
      Navigator.pushNamed(context, "homepage");
    } catch (e) {
      print("Error creating account: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          'حدث خطأ: ${e.toString()}',
          style: TextStyle(
            fontFamily: "IBMPlexSansArabic",
          ),
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: AppBar(
                centerTitle: true,
                title: Text('sign up',
                    style: TextStyle(
                      color: Color(0xFF0B5022),
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                      fontFamily: "IBMPlexSansArabic",
                    )),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    buildField('اسم العمل', 'أدخل اسم العمل', business_name),
                    buildField('البريد الإلكتروني',
                        'أدخل البريد الإلكتروني الخاص بالعمل', email),
                    Row(
                      children: [
                        Expanded(
                          child: buildCityDropdown('موقع العمل'),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: buildDropdownWithIcons('نوع العمل', [
                            {
                              'label': 'كمال الاجسام',
                              'image': 'img/damble.png',
                            },
                            {
                              'label': 'اكاديمية كره',
                              'image': 'img/football.png',
                            },
                            {
                              'label': 'مسبح',
                              'image': 'img/bool.png',
                            },
                            {
                              'label': 'فنون قتاليه',
                              'image': 'img/kill.png',
                            },
                          ]),
                        ),
                      ],
                    ),
                    buildDropdown('الجنس', ['ذكر', 'أنثى']),
                    buildImagePicker(
                        'صورة الهوية المدنية', 'أرفع صورة عن الهوية المدنية  '),
                    buildFieldWithIcon(
                      'كلمة السر',
                      'أدخل كلمة السر',
                      Icons.lock,
                      password,
                      obscure: true,
                    ),
                    buildField(
                        'تأكيد كلمة السر',
                        'أدخل كلمة السر مرة أخرى',
                        obscure: true,
                        confirm_password),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: uploadData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD8E4D3),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'إنشاء الحساب',
                          style: TextStyle(
                            color: backgroundColor,
                            fontSize: 18,
                            fontFamily: "IBMPlexSansArabic",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCityDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "IBMPlexSansArabic",
              )),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            hint: Text(
              'اختر المدينة',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: "IBMPlexSansArabic",
              ),
            ),
            items: jordanCities.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: "IBMPlexSansArabic",
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCity = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildField(
    String label,
    String hint,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "IBMPlexSansArabic",
              )),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            obscureText: obscure,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 16,
              fontFamily: "IBMPlexSansArabic",
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 16,
                fontFamily: "IBMPlexSansArabic",
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFieldWithIcon(String label, String hint, IconData icon,
      TextEditingController controller,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "IBMPlexSansArabic",
              )),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            obscureText: obscure,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 16,
              fontFamily: "IBMPlexSansArabic",
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 16,
                fontFamily: "IBMPlexSansArabic",
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(icon),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownWithIcons(
      String label, List<Map<String, dynamic>> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "IBMPlexSansArabic",
              )),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            hint: Text(
              'اختر $label',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: "IBMPlexSansArabic",
              ),
            ),
            items: items.map((Map<String, dynamic> item) {
              return DropdownMenuItem<String>(
                value: item['label'],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      item['label'],
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: "IBMPlexSansArabic",
                      ),
                    ),
                    SizedBox(width: 10),
                    Image.asset(
                      item['image'],
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (item) {
              setState(() {
                selected_item = item;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "IBMPlexSansArabic",
              )),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            hint: Text(
              'اختر $label',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: "IBMPlexSansArabic",
              ),
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: "IBMPlexSansArabic",
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              gender = value;
            },
          ),
        ],
      ),
    );
  }

  Widget buildImagePicker(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "IBMPlexSansArabic",
              )),
          const SizedBox(height: 5),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt, color: backgroundColor),
                  onPressed: () {
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
                Expanded(
                  child: Text(
                    hint,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "IBMPlexSansArabic",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
