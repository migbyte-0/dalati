import '../entities/item.dart';

abstract class ItemRepository {
  Future<void> addItem(Item item);
  Stream<List<Item>> getItems(bool isLostItem, String? category);
}
