class AddReviewParams {
  final int rating;
  final String comment;
  final String propertyId;
  final String userId;

  AddReviewParams({
    required this.rating,
    required this.comment,
    required this.propertyId,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      "rating": rating,
      "comment": comment,
      "property_id": propertyId,
      "user_id": userId,
    };
  }
}
