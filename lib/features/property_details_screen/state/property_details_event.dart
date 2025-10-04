import '../data/models/add_review_params.dart';

abstract class PropertyDetailsEvent {}

class FetchPropertyDetails extends PropertyDetailsEvent {
  final String propertyId;

  FetchPropertyDetails(this.propertyId);
}

class FetchPropertyReviews extends PropertyDetailsEvent {
  final String propertyId;

  FetchPropertyReviews(this.propertyId);
}

class AddPropertyReview extends PropertyDetailsEvent {
  final AddReviewParams params;

  AddPropertyReview(this.params);
}
