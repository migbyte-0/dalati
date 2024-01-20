import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalati/features/category/data/models/category_model.dart';
import 'package:flutter/foundation.dart';

class CategoryDataSource {
  final FirebaseFirestore firestore;

  CategoryDataSource({required this.firestore});

  Stream<List<CategoryModel>> getCategories() {
    return firestore.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CategoryModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}
