import 'package:flutter/foundation.dart';
import '../models/app_category.dart';
import '../repositories/category_repository.dart';
import '../core/categories.dart' as local;
import '../core/utils/txt_normalize.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository;
  List<AppCategory> _categories = [];

  CategoryProvider(this._repository);

  List<AppCategory> get categories => _categories;

  Future<void> load() async {
    _categories = await _repository.load();
    notifyListeners();
  }

  int? idForDisplayName(String displayName) {
    final target = normalizeAz(displayName);
    final match = _categories.where((c) => normalizeAz(c.displayName) == target);
    return match.isEmpty ? null : match.first.id;
  }

  Future<void> seedMissing() async {
    await load(); // serverde hansi category olmagini baxiriq , sonra lazim olanlari elave etmeyi
    for (final localCategory in local.kCategories) {
      final exists = idForDisplayName(localCategory.label) != null;
      if (!exists) {
        debugPrint('Создаю на сервере: ${localCategory.label}');
        final name = normalizeAz(localCategory.label).toUpperCase();
        await _repository.add(name, localCategory.label);
      }
    }
    await load(); // seeding den sonra tekrar oxunma
  }
}