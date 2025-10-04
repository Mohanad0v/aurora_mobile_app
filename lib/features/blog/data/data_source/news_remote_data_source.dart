import 'package:aurora_app/core/constants/app_url/app_url_strings.dart';
import 'package:dio/dio.dart';
import '../../../../core/networking/dio/dio_client.dart';
import '../models/news_model.dart';

class NewsRemoteDataSource {
  final DioClient dioClient; // For protected endpoints
  final Dio dio; // For public endpoints

  const NewsRemoteDataSource({required this.dioClient, required this.dio});

  /// Fetch list of news
  Future<List<NewsModel>> getNews({int page = 1}) async {
    try {
      final response = await dio.get('${AppUrls.getNews}?page=$page');

      if (response.data['success'] != true || response.data['news'] == null) {
        throw Exception('Failed to fetch news');
      }

      final List<dynamic> newsJson = response.data['news'];
      final newsList = newsJson.map((json) => NewsModel.fromJson(json)).toList();

      return newsList;
    } catch (e) {
      throw Exception('NewsRemoteDataSource.getNews failed: $e');
    }
  }

  /// Fetch single news by ID (optional)
  Future<NewsModel> getNewsById(String id) async {
    try {
      final response = await dio.get('${AppUrls.getNews}/$id');

      if (response.data['success'] != true || response.data['news'] == null) {
        throw Exception('Failed to fetch news by ID');
      }

      return NewsModel.fromJson(response.data['news']);
    } catch (e) {
      throw Exception('NewsRemoteDataSource.getNewsById failed: $e');
    }
  }
}
