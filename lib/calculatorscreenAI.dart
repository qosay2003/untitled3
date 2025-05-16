import 'package:flutter/material.dart';
import 'foodservice.dart'; // تأكد أن المسار صحيح حسب مشروعك

class CalorieCalculatorScreen extends StatefulWidget {
  const CalorieCalculatorScreen({super.key});

  @override
  State<CalorieCalculatorScreen> createState() =>
      _CalorieCalculatorScreenState();
}

class _CalorieCalculatorScreenState extends State<CalorieCalculatorScreen> {
  final _foodController = TextEditingController();
  final _weightController = TextEditingController();
  Map<String, dynamic>? result;
  bool loading = false;

  void _searchFood() async {
    if (_foodController.text.trim().isEmpty) {
      setState(() {
        result = {"error": "يرجى إدخال اسم الطعام"};
        loading = false;
      });
      return;
    }

    double weight = 100.0;
    if (_weightController.text.trim().isNotEmpty) {
      String weightText = _weightController.text.trim();
      const arabicToLatin = "٠١٢٣٤٥٦٧٨٩";
      const latin = "0123456789";
      for (int i = 0; i < arabicToLatin.length; i++) {
        weightText = weightText.replaceAll(arabicToLatin[i], latin[i]);
      }
      try {
        weight = double.parse(weightText);
        if (weight <= 0) {
          setState(() {
            result = {"error": "الوزن يجب أن يكون أكبر من 0"};
            loading = false;
          });
          return;
        }
      } catch (e) {
        setState(() {
          result = {"error": "أدخل وزنًا صحيحًا (مثل 150 أو ١٥٠)"};
          loading = false;
        });
        return;
      }
    }

    setState(() => loading = true);
    final data =
        await FoodService.getNutrients(_foodController.text.trim(), weight);
    setState(() {
      result = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAAAAAA),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          SizedBox(
            width: 40,
          ),
          const Text("احسب سعراتك",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          SizedBox(
            width: 40,
          ),
        ],
        backgroundColor: Color(0xFF0B5022),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 500,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    width: 00,
                    'img/picAI.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _foodController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText: "أدخل اسم الطعام",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText:
                      "وزن الحصة (غرام) (مثل 150 أو ١٥٠) (اختياري، افتراضي 100)",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : _searchFood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B5022),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("ابحث",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 20),
              if (loading) const Center(child: CircularProgressIndicator()),
              if (result != null && result!["nutrients"] != null)
                Expanded(
                  child: Card(
                    margin: const EdgeInsets.all(0),
                    child: ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        ListTile(
                          title: Text(
                            "الطعام: ${result!["name"]}",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(),
                        const ListTile(
                          title: Text(
                            "\u202B📊 القيم الغذائية لكل 100 جم:\u202C",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ..._buildNutrientList(result!["baseNutrients"]),
                        if (result!["weight"] != 100.0) ...[
                          const Divider(),
                          ListTile(
                            title: Text(
                              "\u202B📊 القيم الغذائية لـ ${result!["weight"]} جم:\u202C",
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ..._buildNutrientList(result!["nutrients"]),
                        ],
                        const Divider(),
                        const ListTile(
                          title: Text(
                            "إذا كانت القيم غير دقيقة، حاول تحديد الطعام (مثل 'تفاح خام').",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 20, 77, 128),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (result != null && result!["error"] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    result!["error"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNutrientList(Map<String, dynamic> nutrients) {
    return nutrients.entries
        .where((entry) => entry.value != null)
        .map<Widget>((entry) {
      String unit = "غم";
      if (entry.key == "calories") {
        unit = "kcal";
      } else if (entry.key == "sodium" ||
          entry.key == "calcium" ||
          entry.key == "iron" ||
          entry.key == "cholesterol") {
        unit = "ملغم";
      }
      return ListTile(
        title: Text(
          " $unit ${entry.key}: ${entry.value} ",
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }).toList();
  }
}
