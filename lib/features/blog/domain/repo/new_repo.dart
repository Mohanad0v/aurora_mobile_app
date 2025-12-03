import 'package:dartz/dartz.dart';
import '../../../../core/networking/failure.dart';
import '../../data/models/news_model.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsModel>>> getNews({int page = 1});

  Future<Either<Failure, NewsModel>> getNewsById(String id);
}
