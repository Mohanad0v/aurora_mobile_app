import 'package:aurora_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:aurora_app/features/auth/data/datasource/auth_local.dart';
import 'package:aurora_app/features/auth/data/repo/auth_repo_impl.dart';
import 'package:aurora_app/features/auth/presentation/state/auth_bloc.dart';
import 'package:dio/dio.dart';
import '../../networking/dio/dio_client.dart';
import '../injection.dart';

Future<void> authInject() async {
  // Data sources
  locator.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(
      dioClient: locator<DioClient>(),
      dio: locator<Dio>(),
    ),
  );

  // ❌ REMOVE THIS DUPLICATE REGISTRATION
  // locator.registerLazySingleton<AuthLocal>(
  //   () => AuthLocal(cashHelper: locator()),
  // );

  // Repository
  locator.registerLazySingleton<AuthRepositoryImpl>(
        () => AuthRepositoryImpl(
      remoteDataSource: locator<AuthRemoteDataSource>(),
      localDataSource: locator<AuthLocal>(),
      networkInfo: locator(),
    ),
  );

  // Bloc
  locator.registerFactory(
        () => AuthBloc(authRepository: locator<AuthRepositoryImpl>()),
  );
}

