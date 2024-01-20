// lib/data/models/category_model.dart

import '../../domain/entities/entity.dart';

class CategoryModel extends Category {
  const CategoryModel(
      {required String id, required String name, required String imageUrl})
      : super(id: id, name: name, imageUrl: imageUrl);

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      name: map['name'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
    );
  }

  // If needed, you can also add a method to convert the model back to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}
