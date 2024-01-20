import 'package:dalati/core/constants/app_colors.dart';
import 'package:dalati/core/constants/constants_exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lottie/lottie.dart';
import '../bloc/item_bloc.dart'; // Import the ItemBloc
import '../screens/lost_items_details_screen.dart';

class LostItemsList extends StatelessWidget {
  final ItemState state;

  const LostItemsList({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is ItemsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ItemsLoaded) {
      // Cast state to ItemsLoaded to access the items property
      var lostItems = (state as ItemsLoaded).items;

      if (lostItems.isEmpty) {
        return Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(
              'lib/assets/jsons/error.json',
              repeat: false,
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 15),
            const Text(AppTexts.noItemsFound),
          ],
        ));
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        itemCount: lostItems.length,
        itemBuilder: (context, index) {
          final item = lostItems[index];
          final dateFormat = intl.DateFormat('yyyy-MM-dd');
          final formattedDate = dateFormat.format(item.timestamp);
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LostItemDetailsScreen(item: item),
                  ),
                );
              },
              title: Row(
                children: [
                  const Icon(
                    Icons.category,
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(width: 8),
                  Text(item.category),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text('بواسطة: ${item.name}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        size: 20,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text('بتاريخ: $formattedDate'),
                    ],
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      );
    } else if (state is ItemError) {
      return Text("Error: ${(state as ItemError).message}");
    } else {
      return const Text("No items found or error occurred");
    }
  }
}
