import 'package:dartz/dartz.dart';

import '../../../../core/networking/failure.dart';
import '../../data/models/contact_us_params.dart';
import '../../data/models/login_params.dart';
import '../../data/models/user_profile_model.dart';
import '../entites/user_enntity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn({required LoginParams loginParams});

  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, UserProfile>> getUserProfile();

  Future<Either<Failure, bool>> checkAuthStatus();

  Future<void> signOut() async {}

  Future<Either<Failure, void>> submitContact({required ContactUsParams params});
}
