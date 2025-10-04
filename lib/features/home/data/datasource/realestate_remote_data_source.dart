import 'package:dio/dio.dart';

import '../../../../core/constants/app_url/app_url_strings.dart';
import '../../../../core/networking/dio/dio_client.dart';
import '../../../property_details_screen/data/models/add_review_params.dart';
import '../../../property_details_screen/data/models/property_details_model.dart';
import '../../../property_details_screen/data/models/review_model.dart';
import '../../../property_details_screen/data/models/review_response.dart';
import '../models/amenities_response.dart';
import '../models/property_response_model.dart';
import '../models/status_distribution_response.dart';
import '../models/view_over_time_response.dart';
import '../models/view_response.dart';

abstract class RealEstateRemoteDataSource {
  Future<PropertyResponse> getProperties();

  Future<PropertyDetailsModel> getPropertyDetailsById(String id);

  Future<AmenitiesResponse> getAmenities();

  Future<ReviewsResponse> getReviews(String propertyId);

  Future<ReviewModel> addReview(AddReviewParams params);

  Future<ViewsResponse> getViewsStats();

  Future<CompletedDealsResponse> getCompletedDeals();

  Future<ViewsOverTimeResponse> getViewsOverTime();

  Future<StatusDistributionResponse> getStatusDistribution();

  // Wishlist
  Future<List<Property>> getWishlist(String userId);

  Future<void> addToWishlist(String userId, String propertyId);

  Future<void> removeFromWishlist(String userId, String propertyId);

  Future<void> toggleWishlistItem(String userId, String propertyId);
}

class RealEstateRemoteDataSourceImpl implements RealEstateRemoteDataSource {
  final DioClient dioClient;

  RealEstateRemoteDataSourceImpl({required this.dioClient});

  void _validateResponse(Response response, {String defaultMessage = 'Request failed'}) {
    if (response.statusCode != 200 || response.data['success'] != true) {
      final message = response.data['message'] ?? defaultMessage;
      throw Exception(message);
    }
  }

  @override
  Future<PropertyResponse> getProperties() async {
    final response = await dioClient.get(url: AppUrls.getProperties);
    _validateResponse(response, defaultMessage: 'Failed to fetch properties');
    return PropertyResponse.fromJson(response.data);
  }

  @override
  Future<PropertyDetailsModel> getPropertyDetailsById(String id) async {
    final response = await dioClient.get(
      url: AppUrls.getSingleProperty.replaceFirst(':id', id),
    );
    _validateResponse(response, defaultMessage: 'Failed to fetch property details');
    return PropertyDetailsModel.fromJson(response.data['property']);
  }

  @override
  Future<AmenitiesResponse> getAmenities() async {
    final response = await dioClient.get(url: AppUrls.getAmenities);
    _validateResponse(response);
    return AmenitiesResponse.fromJson(response.data);
  }

  @override
  Future<ReviewsResponse> getReviews(String propertyId) async {
    final response = await dioClient.get(
      url: AppUrls.getReviewsByProperty(propertyId),
    );
    _validateResponse(response);
    return ReviewsResponse.fromJson(response.data);
  }

  Future<ReviewModel> addReview(AddReviewParams params) async {
    try {
      final response = await dioClient.post(
        url: AppUrls.addReview,
        data: params.toJson(),
      );

      final status = response.statusCode;
      final data = response.data;

      if (status == 200 || status == 201) {
        if (data is Map<String, dynamic>) {
          final reviewJson = data['review'] is Map<String, dynamic> ? data['review'] : data;

          return ReviewModel(
            id: reviewJson['id']?.toString() ?? '',
            propertyId: reviewJson['propertyId']?.toString() ?? '',
            userName: reviewJson['userName']?.toString() ?? '',
            userEmail: reviewJson['userEmail']?.toString() ?? '',
            comment: reviewJson['comment']?.toString() ?? '',
            rating: (reviewJson['rating'] ?? 0) is int ? reviewJson['rating'] : int.tryParse(reviewJson['rating']?.toString() ?? '0') ?? 0,
            createdAt: reviewJson['createdAt'] != null ? DateTime.tryParse(reviewJson['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
          );
        }

        // Server returns a string success message
        if (data is String) {
          return ReviewModel(
            id: '',
            propertyId: '',
            userName: '',
            userEmail: '',
            comment: data,
            rating: 0,
            createdAt: DateTime.now(),
          );
        }

        throw Exception('Unexpected server response: $data');
      }

      throw Exception('Failed to add review (status code $status)');
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }

  @override
  Future<ViewsResponse> getViewsStats() async {
    final response = await dioClient.get(url: AppUrls.getViews);
    _validateResponse(response);
    return ViewsResponse.fromJson(response.data);
  }

  @override
  Future<CompletedDealsResponse> getCompletedDeals() async {
    final response = await dioClient.get(url: AppUrls.getCompletedTransaction);
    if (response.statusCode != 200 || response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to fetch completed deals');
    }
    return CompletedDealsResponse.fromJson(response.data);
  }

  @override
  Future<ViewsOverTimeResponse> getViewsOverTime() async {
    final response = await dioClient.get(url: AppUrls.getViewsOverTime);
    _validateResponse(response);
    return ViewsOverTimeResponse.fromJson(response.data);
  }

  @override
  Future<StatusDistributionResponse> getStatusDistribution() async {
    final response = await dioClient.get(url: AppUrls.statusDistribution);
    _validateResponse(response);
    return StatusDistributionResponse.fromJson(response.data);
  }

  @override
  Future<List<Property>> getWishlist(String userId) async {
    final response = await dioClient.get(
      url: AppUrls.getUserWishlist.replaceFirst(':id', userId),
    );
    _validateResponse(response, defaultMessage: 'Failed to fetch wishlist');
    final wishlistData = response.data['wishlist'] as List<dynamic>? ?? [];
    return wishlistData.map((e) => Property.fromJson(e)).toList();
  }

  @override
  Future<void> addToWishlist(String userId, String propertyId) async {
    final response = await dioClient.post(
      url: AppUrls.addPropertyToWishList,
      data: {"userId": userId, "propertyId": propertyId},
    );
    _validateResponse(response, defaultMessage: 'Failed to add to wishlist');
  }

  @override
  Future<void> removeFromWishlist(String userId, String propertyId) async {
    final response = await dioClient.post(
      url: AppUrls.removePropertyToWishList,
      data: {"userId": userId, "propertyId": propertyId},
    );
    _validateResponse(response, defaultMessage: 'Failed to remove from wishlist');
  }

  @override
  Future<void> toggleWishlistItem(String userId, String propertyId) async {
    final wishlist = await getWishlist(userId);
    final propertyIds = wishlist.map((p) => p.id).toList();

    if (propertyIds.contains(propertyId)) {
      await removeFromWishlist(userId, propertyId);
    } else {
      await addToWishlist(userId, propertyId);
    }
  }
}
