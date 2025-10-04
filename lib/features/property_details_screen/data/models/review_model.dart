
import '../../../home/domain/entity/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    required String id,
    required int rating,
    required String comment,
    required String userName,
    required String userEmail,
    required String propertyId,
    required DateTime createdAt,
  }) : super(
    id: id,
    rating: rating,
    comment: comment,
    userName: userName,
    userEmail: userEmail,
    propertyId: propertyId,
    createdAt: createdAt,
  );

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      userName: json['user_id']?['name'] ?? 'Unknown',
      userEmail: json['user_id']?['email'] ?? '',
      propertyId: json['property_id'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'rating': rating,
      'comment': comment,
      'user_id': {
        'name': userName,
        'email': userEmail,
      },
      'property_id': {'_id': propertyId},
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
