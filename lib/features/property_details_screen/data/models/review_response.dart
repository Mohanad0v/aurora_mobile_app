import 'package:aurora_app/features/property_details_screen/data/models/review_model.dart';

class ReviewsResponse {
  final bool success;
  final List<ReviewModel> reviews;

  ReviewsResponse({
    required this.success,
    required this.reviews,
  });

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) {
    return ReviewsResponse(
      success: json['success'] ?? false,
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => ReviewModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }
}
