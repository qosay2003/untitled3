import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

const String USDA_API_KEY =
    "16SCvDVN1xXNpt8aZFaGVbdkMbKCnYxZNoEp9qPK"; // استبدل بمفتاح USDA الخاص بك
const String SPOONACULAR_API_KEY =
    "c14929cd158c421989db8dff8bdc82b3"; // استبدل بمفتاح Spoonacular الخاص بك

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

      // البحث في CSV أولاً
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

      // تحديد ما إذا كان النص بالعربية
      bool isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(foodName);
      String translatedFood = foodName.toLowerCase();

      // ترجمة إذا كان بالعربية
      if (isArabic) {
        translatedFood = await _translateFood(foodName);
        if (translatedFood == foodName.toLowerCase()) {
          return {
            "error":
                "فشل في الترجمة. أدخل الاسم بالإنجليزية أو تحقق من الاتصال."
          };
        }
      }

      // البحث في USDA API
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
                } else if (nutrientName == "protein")
                  nutrients["protein"] = value;
                else if (nutrientName == "carbohydrate, by difference")
                  nutrients["carbohydrates"] = value;
                else if (nutrientName == "total lipid (fat)")
                  nutrients["fat"] = value;
                else if (nutrientName == "fiber, total dietary")
                  nutrients["fiber"] = value;
                else if (nutrientName == "sugars, total")
                  nutrients["sugars"] = value;
                else if (nutrientName == "sodium")
                  nutrients["sodium"] = value;
                else if (nutrientName == "calcium")
                  nutrients["calcium"] = value;
                else if (nutrientName == "iron")
                  nutrients["iron"] = value;
                else if (nutrientName == "cholesterol")
                  nutrients["cholesterol"] = value;
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

      // البحث في Spoonacular API
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
        .firstWhere((n) => n["name"] == name,
            orElse: () => {"amount": 0.0})["amount"]
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

  static Map<String, dynamic> _calculateNutrients(
      Map<String, dynamic> nutrients, double weightFactor) {
    return nutrients.map((key, value) => MapEntry(
        key, value != null ? (value * weightFactor).toStringAsFixed(2) : null));
  }
}
