import 'dart:developer';
import 'package:aurora_app/core/constants/app_url/app_url_strings.dart';
import 'package:dio/dio.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/networking/dio/dio_client.dart';
import '../models/contact_us_params.dart';
import '../models/login_params.dart';
import '../models/user_model.dart';
import '../models/user_profile_model.dart';
import 'auth_local.dart';

class AuthRemoteDataSource {
  final DioClient dioClient; // Authenticated endpoints
  final Dio dio; // Public endpoints

  const AuthRemoteDataSource({
    required this.dioClient,
    required this.dio,
  });

  /// 🔑 Login
  Future<UserModel> signIn({required LoginParams params}) async {
    return _request<UserModel>(
      () => dio.post(AppUrls.login, data: params.toJson()),
      (data) => UserModel.fromJson(data),
      'Login failed',
      expectSuccessKey: true, // login has success:true
    );
  }

  /// 📝 Sign up
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      AppUrls.register,
      data: {'name': name, 'email': email, 'password': password},
    );

    // Treat 200 or 201 as success
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return UserModel.fromJson(data);
      }
      throw Exception('Unexpected response format: $data');
    }

    throw Exception('SignUp failed with status code ${response.statusCode}');
  }

  /// 👤 Get User Profile (Auth required)
  Future<UserProfile> getUserProfile() async {
    final token = locator.get<AuthLocal>().getAuthToken();
    if (token == null || token.isEmpty) {
      throw Exception('No auth token available');
    }

    return _request<UserProfile>(
      () => dioClient.get(url: AppUrls.getCurrentUser),
      (data) => UserProfile.fromJson(data),
      'Failed to fetch profile',
      expectSuccessKey: false, // raw JSON, no 'success'
    );
  }

  /// 🔥 Generic Request Handler
  Future<T> _request<T>(
    Future<Response> Function() apiCall,
    T Function(Map<String, dynamic>) parser,
    String errorMessage, {
    bool expectSuccessKey = false,
  }) async {
    try {
      final response = await apiCall();
      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw Exception('$errorMessage: Invalid response format');
      }

      // Only check 'success' key if expected (login/signup)
      if (expectSuccessKey && data['success'] != true) {
        throw Exception('$errorMessage: Unsuccessful response');
      }

      return parser(data);
    } catch (e, stack) {
      log('$errorMessage: $e', stackTrace: stack);
      rethrow;
    }
  }

  /// 📩 Submit Contact Us Form
  Future<void> sendContactMessage({required ContactUsParams params}) async {
    try {
      final response = await dioClient.post(
        url: AppUrls.contactForm, // define this in AppUrls
        data: params.toJson(),    // ✅ FIXED: send JSON map
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return; // ✅ success
      } else {
        throw Exception(
          'Contact form failed with status: ${response.statusCode}',
        );
      }
    } catch (e, stack) {
      log('Contact API Error: $e', stackTrace: stack);
      rethrow;
    }
  }
}
