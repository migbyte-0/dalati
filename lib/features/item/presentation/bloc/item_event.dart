part of 'item_bloc.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

class LoadItems extends ItemEvent {
  final bool isLostItem;
  final String? category;

  const LoadItems({
    required this.isLostItem,
    this.category,
  });
}

class AddItemEvent extends ItemEvent {
  final Item item;

  const AddItemEvent(this.item);
}
