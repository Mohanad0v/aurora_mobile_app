import 'package:aurora_app/core/injection/injection.dart';
import 'package:aurora_app/features/blog/data/data_source/news_remote_data_source.dart';
import 'package:aurora_app/features/blog/data/repo_impl/news_repo_impl.dart';
import 'package:aurora_app/features/blog/presentation/state/news_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/networking/network_info.dart';

Future<void> blogInject() async {
  print('Blog injection started');

  // ---------------- Service ----------------
  locator.registerLazySingleton<NewsRemoteDataSource>(
        () => NewsRemoteDataSource(
      dioClient: locator(),
      dio: locator<Dio>(),
    ),
  );

  // ---------------- Repository ----------------
  locator.registerLazySingleton<NewsRepositoryImpl>(
        () => NewsRepositoryImpl(
      remoteDataSource: locator<NewsRemoteDataSource>(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );

  // ---------------- Bloc ----------------
  locator.registerFactory<NewsBloc>(
        () => NewsBloc(repository: locator<NewsRepositoryImpl>()),
  );
}
