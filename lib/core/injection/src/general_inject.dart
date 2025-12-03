import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ cashing/cash_helper.dart';
import '../../../features/auth/data/datasource/auth_local.dart';
import '../../navigation/navigation_service.dart';
import '../../networking/dio/dio_client.dart';
import '../../networking/network_info.dart';
import '../injection.dart';

class Instance {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }
}

Future<void> generalInject() async {
  final prefs = await Instance.getPrefs();
  locator.registerSingleton<SharedPreferences>(prefs);

  locator.registerSingleton<CashHelper>(CashHelper(prefs));

  locator.registerLazySingleton<AuthLocal>(
    () => AuthLocal(cashHelper: locator<CashHelper>()),
  );

  locator.registerLazySingleton<NavigationService>(() => NavigationService());

  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  locator.registerLazySingleton<Dio>(() => Dio());

  locator.registerLazySingleton<DioClient>(
    () => DioClient(
      dio: locator<Dio>(),
      authLocal: locator<AuthLocal>(),
    ),
  );
}
