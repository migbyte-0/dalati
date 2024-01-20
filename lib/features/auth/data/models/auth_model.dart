import '../../domain/entities/auth_entities.dart';

class AuthModel extends Auth {
  // البناء من نموذج البيانات

  const AuthModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.email,
  });

  // إنشاء نموذج من JSON
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
    );
  }

  // تحويل النموذج إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
