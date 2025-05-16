import 'package:flutter/material.dart';

class BmiCalculator extends StatefulWidget {
  const BmiCalculator({super.key});

  @override
  _BmiCalculatorState createState() => _BmiCalculatorState();
}

class _BmiCalculatorState extends State<BmiCalculator> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'male';
  double _activityFactor = 1.2;
  double _bmr = 0.0;
  double _tdee = 0.0;

  void calculateBMR() {
    double weight = double.tryParse(_weightController.text) ?? 0;
    double height = double.tryParse(_heightController.text) ?? 0;
    int age = int.tryParse(_ageController.text) ?? 0;

    setState(() {
      _bmr = _gender == 'male'
          ? (10 * weight) + (6.25 * height) - (5 * age) + 5
          : (10 * weight) + (6.25 * height) - (5 * age) - 161;
      _tdee = _bmr * _activityFactor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAAAAAA),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Text(
            "حاسبة السعرات الحرارية",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: "IBMPlexSansArabic",
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
        backgroundColor: Color(0xFF0B5022),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                      ),
                      child: Image.asset(
                        'img/bimcal.png',
                        height: 150,
                        width: 500,
                        fit: BoxFit.fill,
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'أدخل وزنك بالكيلوغرام',
                              style: TextStyle(
                                  fontFamily: "IBMPlexSansArabic",
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B5022)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _weightController,
                              decoration: InputDecoration(
                                labelText: 'الوزن (كجم)',
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'اختر جنسك',
                              style: TextStyle(
                                  fontFamily: "IBMPlexSansArabic",
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B5022)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: DropdownButton<String>(
                                  value: _gender,
                                  items: <String>['male', 'female']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                          value == 'male' ? 'ذكر' : 'أنثى',
                                          style: TextStyle(
                                              fontFamily: "IBMPlexSansArabic",
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0B5022)),
                                          textAlign: TextAlign.start),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _gender = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'أدخل طولك بالسنتيمتر',
                              style: TextStyle(
                                  fontFamily: "IBMPlexSansArabic",
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B5022)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _heightController,
                              decoration: InputDecoration(
                                labelText: 'الطول (سم)',
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'أدخل عمرك بالسنوات',
                              style: TextStyle(
                                  fontFamily: "IBMPlexSansArabic",
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B5022)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _ageController,
                              decoration: InputDecoration(
                                labelText: 'العمر (سنة)',
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'اختر مستوى نشاطك اليومي',
                          style: TextStyle(
                              fontFamily: "IBMPlexSansArabic",
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B5022)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: DropdownButton<double>(
                              value: _activityFactor,
                              items: [
                                {'label': 'خامل', 'value': 1.2},
                                {'label': 'نشاط خفيف', 'value': 1.375},
                                {'label': 'نشاط متوسط', 'value': 1.55},
                                {'label': 'نشاط عالي', 'value': 1.725},
                                {'label': 'نشاط عالي جدًا', 'value': 1.9},
                              ].map<DropdownMenuItem<double>>((dynamic item) {
                                return DropdownMenuItem<double>(
                                  value: item['value'],
                                  child: Text(item['label'],
                                      style: TextStyle(
                                        fontFamily: "IBMPlexSansArabic",
                                      ),
                                      textAlign: TextAlign.right),
                                );
                              }).toList(),
                              onChanged: (double? newValue) {
                                setState(() {
                                  _activityFactor = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: calculateBMR,
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.grey,
                        elevation: 10,
                        backgroundColor: Color(0xFF0B5022),
                      ),
                      child: Text(
                        'حساب',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "IBMPlexSansArabic",
                            fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text('  سعره حرارية: BMR: ${_bmr.toStringAsFixed(2)}  ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "IBMPlexSansArabic"),
                      textAlign: TextAlign.right),
                  Text(
                      ' سعرة حرارية يومياََ: TDEE: ${_tdee.toStringAsFixed(2)} ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "IBMPlexSansArabic"),
                      textAlign: TextAlign.right),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
