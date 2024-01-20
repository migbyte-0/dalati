import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/item.dart';
import '../../domain/usecases/add_item_usecase.dart';
import '../../domain/usecases/get_items.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final AddItem addItem;
  final GetItems getItems;

  ItemBloc(this.addItem, this.getItems) : super(ItemsInitial()) {
    on<LoadItems>(_onLoadItems);
    on<AddItemEvent>(_onAddItem);
  }

  Future<void> _onLoadItems(LoadItems event, Emitter<ItemState> emit) async {
    print("Loading items event received");

    emit(ItemsLoading());
    try {
      final items = await getItems(event.isLostItem, event.category).first;
      emit(ItemsLoaded(items));
    } catch (error) {
      emit(ItemError(error.toString()));
    }
  }

  Future<void> _onAddItem(AddItemEvent event, Emitter<ItemState> emit) async {
    print("Adding item event received");

    emit(ItemAdding());
    try {
      await addItem(event.item);
      emit(ItemAdded());
    } catch (error) {
      emit(ItemError(error.toString())); // Handle the error appropriately
    }
  }
}
