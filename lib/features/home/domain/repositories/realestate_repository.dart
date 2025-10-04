import 'package:dartz/dartz.dart';
import '../../../../core/networking/failure.dart';
import '../../data/models/property_response_model.dart';
import '../../../property_details_screen/data/models/property_details_model.dart';
import '../../../property_details_screen/data/models/review_model.dart';
import '../../../property_details_screen/data/models/add_review_params.dart';
import '../../data/models/status_distribution_response.dart';
import '../../data/models/view_over_time_response.dart';
import '../../data/models/view_response.dart';

abstract class RealEstateRepository {
  // ----------------------
  // Properties
  // ----------------------
  Future<Either<Failure, List<Property>>> getProperties();
  Future<Either<Failure, PropertyDetailsModel>> getPropertyDetailsById(String propertyId);

  // ----------------------
  // Amenities
  // ----------------------
  Future<Either<Failure, List<Amenity>>> getAmenities();

  // ----------------------
  // Reviews
  // ----------------------
  /// Fetch all reviews for a given property
  Future<Either<Failure, List<ReviewModel>>> getReviews(String propertyId);

  /// Add a review for a property and return the updated reviews list
  Future<Either<Failure, ReviewModel?>> addReview(AddReviewParams params);

  // ----------------------
  // Views
  // ----------------------
  Future<Either<Failure, ViewsResponse>> getViewsStats();
  Future<Either<Failure, ViewsOverTimeResponse>> getViewsOverTime();

  // ----------------------
  // Status distribution
  // ----------------------
  Future<Either<Failure, StatusDistributionResponse>> getStatusDistribution();

  // ----------------------
  // Wishlist
  // ----------------------
  Future<Either<Failure, List<Property>>> getWishlist(String userId);
  Future<Either<Failure, void>> updateWishlist(String userId, List<String> wishlistIds);
  Future<Either<Failure, void>> toggleWishlistItem(String userId, String propertyId);
  Future<Either<Failure, void>> addToWishlist(String userId, String propertyId);
  Future<Either<Failure, void>> removeFromWishlist(String userId, String propertyId);
  Future<Either<Failure, int>> getCompletedDeals();
}
