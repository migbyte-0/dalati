class Item {
  final String id;
  final String category;
  final String name;
  final String phoneNumber;
  final String description;
  final bool isLostItem;
  final bool isClaimed;
  final DateTime timestamp;
  final String? idNumber; // New field for بطاقات تعريفية
  final String? deviceType; // New field for أجهزة إلكترونية
  final String? vehicleType; // New field for مركبات
  final String? plateNumber; // New field for مركبات
  final String? missingPersonName; // New field for أشخاص

  Item({
    required this.id,
    required this.category,
    required this.name,
    required this.phoneNumber,
    required this.description,
    required this.isLostItem,
    this.isClaimed = false, // default value

    required this.timestamp,
    this.idNumber,
    this.deviceType,
    this.vehicleType,
    this.plateNumber,
    this.missingPersonName,
  });
}
