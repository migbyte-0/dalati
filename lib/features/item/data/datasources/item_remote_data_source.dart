import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalati/features/item/data/models/item_model.dart';

class ItemDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addItem(ItemModel itemModel) {
    // Convert ItemModel to JSON and add it to Firestore
    return firestore.collection('items').add(itemModel.toJson());
  }

  Stream<List<ItemModel>> getItems(bool isLostItem, String? category) {
    Query query = firestore
        .collection('items')
        .where('isLostItem', isEqualTo: isLostItem);
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ItemModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
