import 'dart:developer';

import 'package:aurora_app/core/constants/app_url/app_url_strings.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/networking/error_handler.dart';
import '../../../../core/networking/failure.dart';
import '../../../../core/networking/network_info.dart';
import '../../domain/repositories/realestate_repository.dart';
import '../datasource/realestate_remote_data_source.dart';
import '../../../property_details_screen/data/models/add_review_params.dart';
import '../models/property_response_model.dart';
import '../../../property_details_screen/data/models/property_details_model.dart';
import '../../../property_details_screen/data/models/review_model.dart';
import '../models/search_params.dart';
import '../models/status_distribution_response.dart';
import '../models/view_over_time_response.dart';
import '../models/view_response.dart';

class RealEstateRepoImpl implements RealEstateRepository {
  final NetworkInfo networkInfo;
  final RealEstateRemoteDataSource remoteDataSource;

  RealEstateRepoImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  Future<Either<Failure, T>> _safeCall<T>(Future<T> Function() call) async {
    if (!await networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
    try {
      final result = await call();
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, List<Property>>> getProperties() async {
    return _safeCall(() async => (await remoteDataSource.getProperties()).property);
  }

  @override
  Future<Either<Failure, PropertyDetailsModel>> getPropertyDetailsById(String id) async {
    return _safeCall(() async => await remoteDataSource.getPropertyDetailsById(id));
  }

  @override
  Future<Either<Failure, List<Amenity>>> getAmenities() async {
    return _safeCall(() async => (await remoteDataSource.getAmenities()).amenities);
  }

  @override
  Future<Either<Failure, List<ReviewModel>>> getReviews(String propertyId) async {
    return _safeCall(() async => (await remoteDataSource.getReviews(propertyId)).reviews);
  }

  @override
  Future<Either<Failure, ReviewModel?>> addReview(AddReviewParams params) async {
    if (!await networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final review = await remoteDataSource.addReview(params);
      return Right(review);
    } catch (error, st) {
      log('Error adding review: $error', stackTrace: st);
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, ViewsResponse>> getViewsStats() async {
    return _safeCall(() async => await remoteDataSource.getViewsStats());
  }

  @override
  Future<Either<Failure, ViewsOverTimeResponse>> getViewsOverTime() async {
    return _safeCall(() async => await remoteDataSource.getViewsOverTime());
  }

  @override
  Future<Either<Failure, StatusDistributionResponse>> getStatusDistribution() async {
    return _safeCall(() async => await remoteDataSource.getStatusDistribution());
  }

  @override
  Future<Either<Failure, List<Property>>> getWishlist(String userId) async {
    return _safeCall(() async => await remoteDataSource.getWishlist(userId));
  }

  @override
  Future<Either<Failure, void>> addToWishlist(String userId, String propertyId) async {
    return _safeCall(() async => await remoteDataSource.addToWishlist(userId, propertyId));
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(String userId, String propertyId) async {
    return _safeCall(() async => await remoteDataSource.removeFromWishlist(userId, propertyId));
  }

  @override
  Future<Either<Failure, void>> toggleWishlistItem(String userId, String propertyId) async {
    return _safeCall(() async => await remoteDataSource.toggleWishlistItem(userId, propertyId));
  }

  @override
  Future<Either<Failure, void>> updateWishlist(String userId, List<String> propertyIds) async {
    return _safeCall(() async {
      final currentWishlist = await remoteDataSource.getWishlist(userId);
      final currentIds = currentWishlist.map((p) => p.id).toList();

      for (var id in propertyIds) {
        if (!currentIds.contains(id)) {
          await remoteDataSource.addToWishlist(userId, id);
        }
      }

      for (var id in currentIds) {
        if (!propertyIds.contains(id)) {
          await remoteDataSource.removeFromWishlist(userId, id);
        }
      }
    });
  }
  @override
  Future<Either<Failure, int>> getCompletedDeals() async {
    return _safeCall(() async {
      final response = await remoteDataSource.getCompletedDeals();
      return response.count;
    });
  }
}
