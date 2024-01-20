// lib/domain/repositories/category_repository.dart

import '../entities/entity.dart';

abstract class CategoryRepository {
  Stream<List<Category>> getCategories();
}
