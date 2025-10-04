import 'package:aurora_app/features/home/data/datasource/realestate_remote_data_source.dart';
import 'package:aurora_app/features/home/data/repo/realestate_repo_impl.dart';
import 'package:dio/dio.dart';
import '../../../features/home/favorites/presentation/screen/states/favorite_bloc.dart';
import '../../../features/home/presentation/screens/state/property_bloc.dart';
import '../../../features/property_details_screen/state/property_details_bloc.dart';
import '../../networking/dio/dio_client.dart';
import '../injection.dart';
import '../../../../core/networking/network_info.dart';

Future<void> homeInject() async {
  print('Home injection started');
  // ---------------- Data sources ----------------
  locator.registerLazySingleton<RealEstateRemoteDataSource>(
    () => RealEstateRemoteDataSourceImpl(dioClient: locator<DioClient>()),
  );

  // ---------------- Repository ----------------
  locator.registerLazySingleton<RealEstateRepoImpl>(
    () => RealEstateRepoImpl(
      remoteDataSource: locator<RealEstateRemoteDataSource>(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );

  // ---------------- Bloc ----------------
  locator.registerFactory<PropertyBloc>(
    () => PropertyBloc(realEstateRepoImpl: locator<RealEstateRepoImpl>()),
  );
  // ---------------- Bloc for Property Details ----------------
  locator.registerFactory(
    () => PropertyDetailsBloc(repository: locator<RealEstateRepoImpl>()),
  );
  // ---------------- FavoritesBloc ----------------
  locator.registerLazySingleton(() => FavoritesBloc(repo: locator<RealEstateRepoImpl>()));
}
