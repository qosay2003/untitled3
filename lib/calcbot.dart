import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

const String USDA_API_KEY =
    "16SCvDVN1xXNpt8aZFaGVbdkMbKCnYxZNoEp9qPK"; // استبدل بمفتاحك
const String SPOONACULAR_API_KEY =
    "c14929cd158c421989db8dff8bdc82b3"; // استبدل بمفتاحك

class FoodService {
  static Map<String, Map<String, dynamic>> _arabicFoods = {};
  static final GoogleTranslator _translator = GoogleTranslator();

  static Future<void> init() async {
    try {
      final csvString =
          await rootBundle.loadString('assets/arabic_meals_dataset.csv');
      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(csvString);

      for (var row in csvTable.skip(1)) {
        if (row.length < 11) continue;
        String foodName = row[0].toString().trim().toLowerCase();
        _arabicFoods[foodName] = {
          "calories": double.tryParse(row[1].toString()) ?? 0.0,
          "protein": double.tryParse(row[2].toString()) ?? 0.0,
          "carbohydrates": double.tryParse(row[3].toString()) ?? 0.0,
          "fat": double.tryParse(row[4].toString()) ?? 0.0,
          "fiber": double.tryParse(row[5].toString()) ?? 0.0,
          "sugars": double.tryParse(row[6].toString()) ?? 0.0,
          "sodium": double.tryParse(row[7].toString()) ?? 0.0,
          "calcium": double.tryParse(row[8].toString()) ?? 0.0,
          "iron": double.tryParse(row[9].toString()) ?? 0.0,
          "cholesterol": double.tryParse(row[10].toString()) ?? 0.0,
        };
      }
    } catch (e) {
      print("Error loading CSV: $e");
    }
  }

  static Future<Map<String, dynamic>> getNutrients(
      String foodName, double weight) async {
    try {
      String normalizedFood = foodName.trim().toLowerCase();

      if (_arabicFoods.containsKey(normalizedFood)) {
        return {
          "source": "local",
          "name": foodName,
          "nutrients":
              _calculateNutrients(_arabicFoods[normalizedFood]!, weight / 100),
          "baseNutrients": _arabicFoods[normalizedFood],
          "weight": weight,
        };
      }

      bool isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(foodName);
      String translatedFood = foodName.toLowerCase();

      if (isArabic) {
        translatedFood = await _translateFood(foodName);
        if (translatedFood == foodName.toLowerCase()) {
          return {
            "error":
                "Failed to translate. Enter the name in English or check the connection."
          };
        }
      }

      String query = "${Uri.encodeComponent(translatedFood)} raw";
      final url = Uri.parse(
          "https://api.nal.usda.gov/fdc/v1/foods/search?query=$query&api_key=$USDA_API_KEY");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["foods"] != null && data["foods"].isNotEmpty) {
          for (var food in data["foods"]) {
            String description = (food["description"] ?? "").toLowerCase();
            if (description.contains(translatedFood) &&
                !description.contains("cooked") &&
                !description.contains("processed") &&
                !description.contains("juice") &&
                !description.contains("pie")) {
              Map<String, dynamic> nutrients = {
                "calories": null,
                "protein": null,
                "carbohydrates": null,
                "fat": null,
                "fiber": null,
                "sugars": null,
                "sodium": null,
                "calcium": null,
                "iron": null,
                "cholesterol": null,
              };
              for (var nutrient in food["foodNutrients"] ?? []) {
                String nutrientName =
                    (nutrient["nutrientName"] ?? "").toLowerCase();
                double? value = nutrient["value"] != null
                    ? nutrient["value"].toDouble()
                    : null;
                String unit = (nutrient["unitName"] ?? "").toLowerCase();
                if (nutrientName == "energy" && value != null) {
                  if (unit == "kj") value *= 0.239;
                  nutrients["calories"] = value;
                } else if (nutrientName == "protein") {
                  nutrients["protein"] = value;
                } else if (nutrientName == "carbohydrate, by difference") {
                  nutrients["carbohydrates"] = value;
                } else if (nutrientName == "total lipid (fat)") {
                  nutrients["fat"] = value;
                } else if (nutrientName == "fiber, total dietary") {
                  nutrients["fiber"] = value;
                } else if (nutrientName == "sugars, total") {
                  nutrients["sugars"] = value;
                } else if (nutrientName == "sodium") {
                  nutrients["sodium"] = value;
                } else if (nutrientName == "calcium") {
                  nutrients["calcium"] = value;
                } else if (nutrientName == "iron") {
                  nutrients["iron"] = value;
                } else if (nutrientName == "cholesterol") {
                  nutrients["cholesterol"] = value;
                }
              }
              if (nutrients["calories"] != null ||
                  nutrients["protein"] != null) {
                return {
                  "source": "usda",
                  "name": foodName,
                  "translated_name": translatedFood,
                  "nutrients": _calculateNutrients(nutrients, weight / 100),
                  "baseNutrients": nutrients,
                  "weight": weight,
                };
              }
            }
          }
        }
      }

      final spoonUrl = Uri.parse(
          "https://api.spoonacular.com/recipes/complexSearch?query=$translatedFood&apiKey=$SPOONACULAR_API_KEY&addRecipeNutrition=true");
      final spoonResponse = await http.get(spoonUrl);
      if (spoonResponse.statusCode == 200) {
        final data = jsonDecode(spoonResponse.body);
        if (data["results"] != null && data["results"].isNotEmpty) {
          var recipe = data["results"][0];
          var nutrientsData = recipe["nutrition"]["nutrients"];
          Map<String, dynamic> nutrients = {
            "calories": _getNutrientValue(nutrientsData, "Calories") /
                recipe["servings"],
            "protein": _getNutrientValue(nutrientsData, "Protein") /
                recipe["servings"],
            "carbohydrates": _getNutrientValue(nutrientsData, "Carbohydrates") /
                recipe["servings"],
            "fat": _getNutrientValue(nutrientsData, "Fat") / recipe["servings"],
            "fiber":
                _getNutrientValue(nutrientsData, "Fiber") / recipe["servings"],
            "sugars":
                _getNutrientValue(nutrientsData, "Sugar") / recipe["servings"],
            "sodium":
                _getNutrientValue(nutrientsData, "Sodium") / recipe["servings"],
            "calcium": _getNutrientValue(nutrientsData, "Calcium") /
                recipe["servings"],
            "iron":
                _getNutrientValue(nutrientsData, "Iron") / recipe["servings"],
            "cholesterol": _getNutrientValue(nutrientsData, "Cholesterol") /
                recipe["servings"],
          };
          return {
            "source": "spoonacular",
            "name": foodName,
            "translated_name": translatedFood,
            "nutrients": _calculateNutrients(nutrients, weight / 100),
            "baseNutrients": nutrients,
            "weight": weight,
          };
        }
      }

      return {"error": "لم يتم العثور على معلومات عن '$foodName'"};
    } catch (e) {
      return {"error": "حدث خطأ: $e"};
    }
  }

  static double _getNutrientValue(List<dynamic> nutrients, String name) {
    return nutrients
        .firstWhere(
          (n) => n["name"] == name,
          orElse: () => {"amount": 0.0},
        )["amount"]
        .toDouble();
  }

  static Future<String> _translateFood(String foodName) async {
    try {
      final translation =
          await _translator.translate(foodName, from: 'ar', to: 'en');
      return translation.text.toLowerCase();
    } catch (e) {
      return foodName.toLowerCase();
    }
  }

  static Map<String, double?> _calculateNutrients(
      Map<String, dynamic> baseNutrients, double factor) {
    final Map<String, double?> adjusted = {};
    baseNutrients.forEach((key, value) {
      if (value is num) {
        adjusted[key] = value * factor;
      } else {
        adjusted[key] = null;
      }
    });
    return adjusted;
  }
}

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

  @override
  void initState() {
    super.initState();
    FoodService.init();
  }

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

    setState(() {
      loading = true;
      result = null;
    });
    final data =
        await FoodService.getNutrients(_foodController.text.trim(), weight);
    setState(() {
      result = data;
      loading = false;
    });
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
        unit = "ملغ";
      }
      final arabicNames = {
        "calories": "سعرات حرارية",
        "protein": "بروتين",
        "carbohydrates": "كربوهيدرات",
        "fat": "دهون",
        "fiber": "ألياف",
        "sugars": "سكريات",
        "sodium": "صوديوم",
        "calcium": "كالسيوم",
        "iron": "حديد",
        "cholesterol": "كوليسترول",
      };
      return ListTile(
        title: Text(
          "${arabicNames[entry.key] ?? entry.key} : ${entry.value!.toStringAsFixed(2)} $unit",
          style: const TextStyle(fontSize: 18),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAAAAAA),
      appBar: AppBar(
          backgroundColor: Color(0xFF0B5022),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Text(
              "حاسبة السعرات الحرارية",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              width: 40,
            ),
          ]),
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
}
