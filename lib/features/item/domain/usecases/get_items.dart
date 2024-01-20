import '../entities/item.dart';
import '../repositories/item_repository.dart';

class GetItems {
  final ItemRepository repository;

  GetItems(this.repository);

  Stream<List<Item>> call(bool isLostItem, String? category) {
    return repository.getItems(isLostItem, category);
  }
}
