import '../../domain/entities/item.dart';
import '../../domain/repositories/item_repository.dart';
import '../datasources/item_remote_data_source.dart';
import '../models/item_model.dart';

class ItemRepositoryImpl implements ItemRepository {
  final ItemDataSource remoteDataSource;

  ItemRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addItem(Item item) async {
    ItemModel itemModel = ItemModel(
      id: item.id,
      category: item.category,
      name: item.name,
      phoneNumber: item.phoneNumber,
      description: item.description,
      isLostItem: item.isLostItem,
      isClaimed: item.isClaimed,
      timestamp: item.timestamp,
    );
    await remoteDataSource.addItem(itemModel);
  }

  @override
  Stream<List<Item>> getItems(bool isLostItem, String? category) {
    return remoteDataSource.getItems(isLostItem, category).map((models) {
      return models
          .map((model) => Item(
                id: model.id,
                category: model.category,
                name: model.name,
                phoneNumber: model.phoneNumber,
                description: model.description,
                isLostItem: model.isLostItem,
                isClaimed: model.isClaimed,
                timestamp: model.timestamp,
              ))
          .toList();
    });
  }
}
