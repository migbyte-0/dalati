import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class SaveUsername {
  final AuthRepository repository;

  SaveUsername(this.repository);

  // تنفيذ عملية حفظ اسم المستخدم
  Future<Either<Failure, void>> execute(String username) async {
    return repository.saveUsername(username);
  }
}
