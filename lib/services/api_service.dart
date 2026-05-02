import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1/";

  static Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse("${baseUrl}categories.php"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['categories'];
    } else {
      throw Exception("Gagal mengambil kategori");
    }
  }

  static Future<List<dynamic>> fetchMealsByCategory(String category) async {
    final response = await http.get(Uri.parse("${baseUrl}filter.php?c=$category"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['meals'];
    } else {
      throw Exception("Gagal mengambil daftar masakan");
    }
  }

  static Future<Map<String, dynamic>> fetchMealDetail(String id) async {
    final response = await http.get(Uri.parse("${baseUrl}lookup.php?i=$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['meals'][0];
    } else {
      throw Exception("Gagal mengambil detail masakan");
    }
  }

  static Future<List<dynamic>> searchMeals(String keyword) async {
    final response = await http.get(Uri.parse("${baseUrl}search.php?s=$keyword"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['meals'] ?? [];
    } else {
      throw Exception("Gagal mencari masakan");
    }
  }
}
