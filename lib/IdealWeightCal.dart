import 'package:flutter/material.dart';

class IdealWeightCalculator extends StatefulWidget {
  const IdealWeightCalculator({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IdealWeightCalculatorState createState() => _IdealWeightCalculatorState();
}

class _IdealWeightCalculatorState extends State<IdealWeightCalculator> {
  final _heightController = TextEditingController();
  String _gender = 'male';
  double _idealWeight = 0.0;

  void calculateIdealWeight() {
    double height = double.tryParse(_heightController.text) ?? 0;
    setState(() {
      _idealWeight = _gender == 'male' ? height - 100 : height - 104;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAAAAAA),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Text(
            "حاسبة الوزن المثالي ",
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
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                    'img/mezan.png',
                    height: 150,
                    width: 500,
                    fit: BoxFit.fill,
                  )),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'أدخل طولك بالسنتيمتر',
                          style: TextStyle(
                              fontFamily: "IBMPlexSansArabic",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B5022)),
                        ),
                        SizedBox(
                          height: 15,
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
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'اختر جنسك',
                          style: TextStyle(
                              fontFamily: "IBMPlexSansArabic",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B5022)),
                        ),
                        SizedBox(
                          height: 15,
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
                                        color: Color(0xFF0B5022),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
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
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: calculateIdealWeight,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B5022),
                  ),
                  child: const Text(
                    'حساب',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "IBMPlexSansArabic"),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'الوزن المثالي: ${_idealWeight.toStringAsFixed(2)} كجم',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "IBMPlexSansArabic"),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
