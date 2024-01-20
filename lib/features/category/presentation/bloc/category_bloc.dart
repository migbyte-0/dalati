import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/entity.dart';
import '../../domain/repositories/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = repository.getCategories();
        await for (final categoryList in categories) {
          emit(CategoryLoaded(categoryList));
        }
      } catch (e) {
        print("Error loading categories: $e"); // Add this line
        emit(CategoryError());
      }
    });
  }
}
