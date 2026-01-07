import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      // Cache token and user data
      if (user.token != null) {
        await localDataSource.cacheToken(user.token!);
      }
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(
      String email, String password, String username, String fullName) async {
    try {
      final user =
          await remoteDataSource.register(email, password, username, fullName);
      // Usually register also logs in, but depends on backend.
      // Assuming register returns user but maybe not token immediately if email verification is needed.
      // But based on mavoo analysis, register just returns success message usually.
      // Let's check remoteDataSource implementation later.
      // For now, if user has token, cache it.
      if (user.token != null) {
        await localDataSource.cacheToken(user.token!);
        await localDataSource.cacheUser(user);
      }
      return Right(user);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await localDataSource.getLastUser();
      if (user != null) {
        return Right(user);
      } else {
        return const Left(CacheFailure('No user cached'));
      }
    } catch (e) {
      return const Left(CacheFailure('Error retrieving cached user'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> socialLogin(
      Map<String, dynamic> userData) async {
    try {
      final user = await remoteDataSource.socialLogin(userData);
      // Cache token and user data
      if (user.token != null) {
        await localDataSource.cacheToken(user.token!);
      }
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile(Map<String, dynamic> data) async {
    try {
      final user = await remoteDataSource.updateProfile(data);
      // Update local cache with new user data
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
