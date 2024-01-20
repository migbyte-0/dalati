// lib/data/repositories/category_repository_impl.dart

import 'package:dalati/features/category/data/models/category_model.dart';
import 'package:flutter/foundation.dart';

import '../../domain/repositories/category_repository.dart';
import '../datasources/category_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource dataSource;

  CategoryRepositoryImpl(this.dataSource);

  @override
  Stream<List<CategoryModel>> getCategories() {
    return dataSource
        .getCategories()
        .map((categories) => categories.map((category) {
              return CategoryModel(
                  id: category.id,
                  name: category.name,
                  imageUrl: category.imageUrl);
            }).toList());
  }
}
