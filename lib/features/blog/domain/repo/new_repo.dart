import 'package:dartz/dartz.dart';
import '../../../../core/networking/failure.dart';
import '../../data/models/news_model.dart';

abstract class NewsRepository {
  /// Fetch a list of news, optionally paginated
  Future<Either<Failure, List<NewsModel>>> getNews({int page = 1});

  /// Fetch a single news item by its ID
  Future<Either<Failure, NewsModel>> getNewsById(String id);
}
