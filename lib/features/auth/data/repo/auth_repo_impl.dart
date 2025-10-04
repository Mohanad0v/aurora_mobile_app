import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../domain/entites/user_enntity.dart';
import '../../domain/repo/auth_repo.dart';
import '../datasource/auth_local.dart';
import '../datasource/auth_remote_data_source.dart';
import '../models/contact_us_params.dart';
import '../models/login_params.dart';
import '../models/user_profile_model.dart';
import '../../../../core/networking/network_info.dart';
import '../../../../core/networking/error_handler.dart';
import '../../../../core/networking/failure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocal localDataSource;
  final NetworkInfo networkInfo;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  /// 🔑 Login → returns UserEntity (with token)
  @override
  Future<Either<Failure, UserEntity>> signIn({
    required LoginParams loginParams,
  }) async {
    return _safeCall<UserEntity>(
      () async {
        final user = await remoteDataSource.signIn(params: loginParams);
        _validateUser(user);
        await localDataSource.saveAuthToken(user.token!);
        return user;
      },
      context: 'SignIn',
    );
  }

  /// 📝 Sign Up → returns UserEntity (with token)
  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return _safeCall<UserEntity>(
      () async {
        final user = await remoteDataSource.signUp(
          name: name,
          email: email,
          password: password,
        );
        _validateUser(user);
        await localDataSource.saveAuthToken(user.token!);
        return user;
      },
      context: 'SignUp',
    );
  }

  /// 👤 Get full user profile → returns UserProfile (without token)
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    return _safeCall<UserProfile>(
      () async {
        final profile = await remoteDataSource.getUserProfile();
        if (profile.id.isEmpty) {
          throw Exception('Invalid user profile data');
        }
        return profile;
      },
      context: 'GetUserProfile',
    );
  }

  /// ✅ Check if user is authenticated
  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    if (!await networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final token = localDataSource.getAuthToken();
      if (token == null || token.isEmpty) return const Right(false);

      final profileResult = await getUserProfile();
      return profileResult.fold(
        (_) => const Right(false),
        (_) => const Right(true),
      );
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  /// 🔒 Sign out
  @override
  Future<void> signOut() async {
    await localDataSource.removeAuthToken();
  }

  /// 🔑 Validate UserEntity
  void _validateUser(UserEntity user) {
    if (user.id.isEmpty || user.token == null) {
      throw Exception('Invalid user: Missing ID or token');
    }
  }

  /// 🔥 Safe API call wrapper
  Future<Either<Failure, T>> _safeCall<T>(
    Future<T> Function() call, {
    required String context,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final result = await call();
      return Right(result);
    } catch (error, stack) {
      log('$context error: $error', stackTrace: stack);
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, void>> submitContact({required ContactUsParams params}) async {
    if (!await networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      await remoteDataSource.sendContactMessage(
        params: params,
      );
      return const Right(null);
    } catch (error, stack) {
      log('ContactRepository error: $error', stackTrace: stack);
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
