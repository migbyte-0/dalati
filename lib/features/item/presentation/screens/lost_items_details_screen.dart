// lost_item_details_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/item.dart';

class LostItemDetailsScreen extends StatelessWidget {
  final Item item;

  const LostItemDetailsScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    String reversePhoneNumber(String phoneNumber) {
      return phoneNumber.split('').reversed.join();
    }

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('الإسم: ${item.name}'),
              Text('الفئه: ${item.category}'),
              Text('بتاريخ: ${dateFormat.format(item.timestamp)}'),
              Text(
                  'رقم الهاتف: ${reversePhoneNumber(item.phoneNumber)}'), // Reversed phone number
              Text('الوصف: ${item.description}'),
              // ... Add other fields as needed
            ],
          ),
        ),
      ),
    );
  }
}
