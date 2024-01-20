// lib/domain/usecases/get_categories_usecase.dart

import '../entities/entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Stream<List<Category>> call() {
    return repository.getCategories();
  }
}
