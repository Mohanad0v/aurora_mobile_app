import 'package:equatable/equatable.dart';

import '../data/models/property_details_model.dart';
import '../data/models/review_model.dart';

class PropertyDetailsState extends Equatable {
  final bool isLoadingDetails;
  final bool isLoadingReviews;
  final bool isAddingReview; // NEW
  final PropertyDetailsModel? propertyDetails;
  final List<ReviewModel> reviews;
  final String? error;

  const PropertyDetailsState({
    this.isLoadingDetails = false,
    this.isLoadingReviews = false,
    this.isAddingReview = false, // NEW
    this.propertyDetails,
    this.reviews = const [],
    this.error,
  });

  PropertyDetailsState copyWith({
    bool? isLoadingDetails,
    bool? isLoadingReviews,
    bool? isAddingReview, // NEW
    PropertyDetailsModel? propertyDetails,
    List<ReviewModel>? reviews,
    String? error,
  }) {
    return PropertyDetailsState(
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      isLoadingReviews: isLoadingReviews ?? this.isLoadingReviews,
      isAddingReview: isAddingReview ?? this.isAddingReview,
      propertyDetails: propertyDetails ?? this.propertyDetails,
      reviews: reviews ?? this.reviews,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoadingDetails,
        isLoadingReviews,
        isAddingReview,
        propertyDetails,
        reviews,
        error,
      ];
}
