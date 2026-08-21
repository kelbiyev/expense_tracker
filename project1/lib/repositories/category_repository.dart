import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project1/core/ui_strings.dart';
import '../core/api_config.dart';
import '../models/category.dart';

class CategoryRepository {
  Future<List<AppCategory>> load() async {
    final response = await http.get(ApiConfig.categories());
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AppCategory.fromJson(json)).toList();
    } else {
      throw Exception('${UiStrings.categoryLoadError} ${response.statusCode}');
    }
  }

  Future<AppCategory> add(String name, String displayName) async {
    final response = await http.post(
      ApiConfig.categories(),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'displayName': displayName}),
    );
    if (response.statusCode == 200) {
      return AppCategory.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('${UiStrings.categoryAddError} ${response.statusCode}');
    }
  }

  Future<void> remove(int id) async {
    final response = await http.delete(ApiConfig.category(id));
    if (response.statusCode != 200) {
      throw Exception('${UiStrings.categoryDeleteError} ${response.statusCode}');
    }
  }
}