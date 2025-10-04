// import 'package:get_it/get_it.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../ cashing/shared_preferences_service.dart';
// import '../../../features/auth/data/datasource/auth_remote_data_source.dart';
// import '../../../features/auth/presentation/state/auth_bloc.dart';
// import '../../../features/blog/data/data_source/news_remote_data_source.dart';
// import '../../../features/blog/presentation/state/blog_bloc.dart';
// import '../../../features/home/data/datasource/comment_service.dart';
// import '../../../features/home/data/datasource/property_service.dart';
// import '../../../features/home/favorites/presentation/state/favorites_bloc.dart';
// import '../../../features/home/presentation/screens/comment_state/comment_bloc.dart';
// import '../../../features/home/presentation/screens/state/property_bloc.dart';
// import '../../networking/dio_client.dart';
//
// final GetIt getIt = GetIt.instance;
//
// Future<void> configureDependencies() async {
//   // Register SharedPreferences async
//   getIt.registerSingletonAsync<SharedPreferences>(
//     () async => await SharedPreferences.getInstance(),
//   );
//
//   // Register SharedPreferencesService after SharedPreferences is ready
//   getIt.registerSingletonWithDependencies<SharedPreferencesService>(
//     () => SharedPreferencesService(getIt<SharedPreferences>()),
//     dependsOn: [SharedPreferences],
//   );
//
//   getIt.registerLazySingleton<DioClient>(
//     () => DioClient(getIt<SharedPreferencesService>()),
//   );
//
//   getIt.registerLazySingleton<AuthService>(
//     () => AuthService(
//       dioClient: getIt<DioClient>(),
//       sharedPreferencesService: getIt<SharedPreferencesService>(),
//     ),
//   );
//
//   getIt.registerLazySingleton<PropertyService>(
//     () => PropertyService(dioClient: getIt<DioClient>()),
//   );
//
//   getIt.registerLazySingleton<BlogService>(
//     () => BlogService(dioClient: getIt<DioClient>()),
//   );
//
//   getIt.registerLazySingleton<CommentService>(
//     () => CommentService(dioClient: getIt<DioClient>()),
//   );
//
//   getIt.registerFactory<AuthBloc>(
//     () => AuthBloc(authService: getIt<AuthService>()),
//   );
//   getIt.registerFactory<PropertyBloc>(
//     () => PropertyBloc(propertyService: getIt<PropertyService>()),
//   );
//   getIt.registerFactory<FavoritesBloc>(
//     () => FavoritesBloc(propertyService: getIt<PropertyService>()),
//   );
//   getIt.registerFactory<BlogBloc>(
//     () => BlogBloc(blogService: getIt<BlogService>()),
//   );
//   getIt.registerFactory<CommentBloc>(
//     () => CommentBloc(commentService: getIt<CommentService>()),
//   );
//
//   // This makes sure all async singletons are resolved before runApp
//   await getIt.allReady();
// }
