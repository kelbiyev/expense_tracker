import 'package:flutter/foundation.dart';
import '../models/categories_model.dart';
import '../repositories/category_repository.dart';
import '../core/categories.dart' as local;
import '../core/utils/txt_normalize.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository;

  CategoryProvider(this._repository);

  List<CategoriesModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CategoriesModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _categories.isEmpty;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _repository.load();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  CategoriesModel? findByDisplayName(String displayName) {
    final target = normalizeAz(displayName);
    final matches = _categories.where((c) => normalizeAz(c.displayName) == target);
    return matches.isEmpty ? null : matches.first;
  }

  Future<void> seedMissing() async {
    await load();
    for (final localCategory in local.kCategories) {
      final exists = findByDisplayName(localCategory.label) != null;
      if (!exists) {
        debugPrint('Создаю на сервере: ${localCategory.label}');
        final name = normalizeAz(localCategory.label).toUpperCase();
        await _repository.add(name, localCategory.label);
      }
    }
    await load();
  }
}