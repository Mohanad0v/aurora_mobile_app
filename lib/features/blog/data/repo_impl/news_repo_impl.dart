import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../../../core/networking/network_info.dart';
import '../../../../core/networking/error_handler.dart';
import '../../../../core/networking/failure.dart';
import '../data_source/news_remote_data_source.dart';
import '../models/news_model.dart';

class NewsRepositoryImpl {
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  Future<Either<Failure, List<NewsModel>>> getNews({int page = 1}) async {
    if (!await networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final newsModels = await remoteDataSource.getNews(page: page);

      if (newsModels.isEmpty) {
        return Left(DataSource.NOT_FOUND.getFailure());
      }

      return Right(newsModels);
    } catch (error) {
      log('getNews error: $error');
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  Future<Either<Failure, NewsModel>> getNewsById(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final newsModel = await remoteDataSource.getNewsById(id);

      return Right(newsModel);
    } catch (error) {
      log('getNewsById error: $error');
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
