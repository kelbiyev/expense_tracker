import 'package:flutter/foundation.dart';
import '../models/category.dart';
import '../repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository;
  List<AppCategory> _categories = [];

  CategoryProvider(this._repository);

  List<AppCategory> get categories => _categories;

  Future<void> load() async {
    _categories = await _repository.load();
    notifyListeners();
  }

  int? idForKey(String key) {
    final match = _categories.where((c) => c.key == key);
    return match.isEmpty ? null : match.first.id;
  }
}