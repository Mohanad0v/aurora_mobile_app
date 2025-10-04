class ReviewEntity {
  final String id;
  final int rating;
  final String comment;
  final String userName;
  final String userEmail;
  final String propertyId;
  final DateTime createdAt;

  ReviewEntity({
    required this.id,
    required this.rating,
    required this.comment,
    required this.userName,
    required this.userEmail,
    required this.propertyId,
    required this.createdAt,
  });
}
