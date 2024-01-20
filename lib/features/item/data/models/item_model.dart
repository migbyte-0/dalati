import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/item.dart';

class ItemModel extends Item {
  ItemModel({
    required String id,
    required String category,
    required String name,
    required String phoneNumber,
    required String description,
    required bool isLostItem,
    bool isClaimed = false,
    required DateTime timestamp,
    String? idNumber,
    String? deviceType,
    String? vehicleType,
    String? plateNumber,
    String? missingPersonName,
  }) : super(
          id: id,
          category: category,
          name: name,
          phoneNumber: phoneNumber,
          description: description,
          isLostItem: isLostItem,
          isClaimed: isClaimed,
          timestamp: timestamp,
          idNumber: idNumber,
          deviceType: deviceType,
          vehicleType: vehicleType,
          plateNumber: plateNumber,
          missingPersonName: missingPersonName,
        );

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      category: json['category'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      description: json['description'],
      isLostItem: json['isLostItem'],
      isClaimed: json['isClaimed'] ?? false,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      idNumber: json['idNumber'],
      deviceType: json['deviceType'],
      vehicleType: json['vehicleType'],
      plateNumber: json['plateNumber'],
      missingPersonName: json['missingPersonName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'name': name,
      'phoneNumber': phoneNumber,
      'description': description,
      'isLostItem': isLostItem,
      'isClaimed': isClaimed,
      'timestamp': Timestamp.fromDate(timestamp),
      'idNumber': idNumber,
      'deviceType': deviceType,
      'vehicleType': vehicleType,
      'plateNumber': plateNumber,
      'missingPersonName': missingPersonName,
    };
  }
}
