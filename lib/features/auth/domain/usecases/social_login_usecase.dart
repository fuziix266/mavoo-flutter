import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SocialLoginUseCase {
  final AuthRepository repository;

  SocialLoginUseCase(this.repository);

  Future<Either<Failure, User>> call(Map<String, dynamic> userData) async {
    return await repository.socialLogin(userData);
  }
}
