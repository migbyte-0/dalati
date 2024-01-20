import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class UpdatePhoneNumber {
  final AuthRepository repository;

  UpdatePhoneNumber(this.repository);

  // تنفيذ عملية تحديث رقم الهاتف
  Future<Either<Failure, void>> call(String phoneNumber) async {
    return await repository.updatePhoneNumber(phoneNumber);
  }
}
