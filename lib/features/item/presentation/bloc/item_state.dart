part of 'item_bloc.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemsInitial extends ItemState {}

class ItemsLoading extends ItemState {}

class ItemsLoaded extends ItemState {
  final List<Item> items; // Define the 'items' list here

  const ItemsLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class ItemAdding extends ItemState {}

class ItemAdded extends ItemState {}

class ItemError extends ItemState {
  final String message;

  const ItemError(this.message);

  @override
  List<Object> get props => [message];
}
