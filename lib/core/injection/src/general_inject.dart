import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ cashing/cash_helper.dart';
import '../../../features/auth/data/datasource/auth_local.dart';
import '../../navigation/navigation_service.dart';
import '../../networking/dio/dio_client.dart';
import '../../networking/network_info.dart';
import '../injection.dart';

/// Manages SharedPreferences singleton instance
class Instance {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }
}

/// General dependency injection setup
Future<void> generalInject() async {
  // SharedPreferences
  final prefs = await Instance.getPrefs();
  locator.registerSingleton<SharedPreferences>(prefs);

  // Helpers
  locator.registerSingleton<CashHelper>(CashHelper(prefs));

  // Auth Local (token storage)
  locator.registerLazySingleton<AuthLocal>(
        () => AuthLocal(cashHelper: locator<CashHelper>()),
  );

  // Navigation Service
  locator.registerLazySingleton<NavigationService>(() => NavigationService());

  // Network Info
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Dio
  locator.registerLazySingleton<Dio>(() => Dio());

  // DioClient (with token injection)
  locator.registerLazySingleton<DioClient>(
        () => DioClient(
      dio: locator<Dio>(),
      authLocal: locator<AuthLocal>(),
    ),
  );
}
