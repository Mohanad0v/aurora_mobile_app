import 'dart:developer';
import '../../../../core/ cashing/cash_helper.dart';
import '../../../../core/constants/app_url/app_strings.dart';

class AuthLocal {
  final CashHelper _cashHelper;

  AuthLocal({required CashHelper cashHelper}) : _cashHelper = cashHelper;

  Future<void> saveAuthToken(String token) async {
    log(' Saving AuthToken...');
    await _cashHelper.setString(AppStrings.TOKEN_KEY, token);
  }

  String? getAuthToken() {
    final token = _cashHelper.getString(AppStrings.TOKEN_KEY);
    log(' Retrieved AuthToken: $token');
    return token?.isNotEmpty == true ? token : null;
  }

  Future<void> removeAuthToken() async {
    log(' Removing AuthToken...');
    await _cashHelper.remove(AppStrings.TOKEN_KEY);
    log(' AuthToken removed.');
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    log(' Saving RefreshToken...');
    await _cashHelper.setString(AppStrings.REFRESH_TOKEN_KEY, refreshToken);
  }

  String? getRefreshToken() {
    final refreshToken = _cashHelper.getString(AppStrings.REFRESH_TOKEN_KEY);
    log(' Retrieved RefreshToken: $refreshToken');
    return refreshToken?.isNotEmpty == true ? refreshToken : null;
  }

  Future<void> removeRefreshToken() async {
    log(' Removing RefreshToken...');
    await _cashHelper.remove(AppStrings.REFRESH_TOKEN_KEY);
    log(' RefreshToken removed.');
  }
}
