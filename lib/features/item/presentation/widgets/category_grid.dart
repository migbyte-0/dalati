import 'package:flutter/material.dart';

import '../../../../core/constants/constants_exports.dart';
import '../../../../core/shared/widgets/decorators/index.dart';
import '../../../category/presentation/bloc/category_bloc.dart';

class CategoriesGrid extends StatelessWidget {
  final CategoryState state;
  final Function(String) onCategorySelected;

  const CategoriesGrid({
    Key? key,
    required this.state,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is CategoryLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CategoryLoaded) {
      // Cast state to CategoryLoaded to access the categories property
      var categories = (state as CategoryLoaded).categories;

      return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return InkWell(
            onTap: () => onCategorySelected(category.name),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GradientIcon(
                      myChild: Image.network(category.imageUrl, scale: 3),
                      firstGradientColor: AppColors.primaryColor,
                      secondGradientColor: AppColors.infoColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(category.name),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return const Center(child: Text("Error or no categories found"));
    }
  }
}
