// found_item_details_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/item.dart';

class FoundItemDetailsScreen extends StatelessWidget {
  final Item item;

  const FoundItemDetailsScreen({Key? key, required this.item})
      : super(key: key);

  void _claimItem(BuildContext context, String itemId) async {
    print("Attempting to claim item with ID: $itemId");

    try {
      await FirebaseFirestore.instance
          .collection('items')
          .doc(itemId)
          .update({'isClaimed': true});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item successfully claimed')),
      );
    } catch (e) {
      print("Error claiming item: $e");
      if (e is FirebaseException) {
        print("FirebaseException Code: ${e.code}");
        print("FirebaseException Message: ${e.message}");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to claim item')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    String reversePhoneNumber(String phoneNumber) {
      return phoneNumber.split('').reversed.join();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الموجودات')),
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
              Text('رقم الهاتف: ${reversePhoneNumber(item.phoneNumber)}'),
              Text('الوصف: ${item.description}'),
              // ... Add other fields as needed
              FloatingActionButton(
                onPressed: () => _claimItem(context, item.id),
                tooltip: 'Claim',
                child: const Icon(Icons.check),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
