import '../../../../core/constants/app_url/app_url_strings.dart';
import '../../../home/data/models/property_response_model.dart';
import '../../../home/domain/entity/localized_text_entity.dart';
import '../../../home/domain/entity/property_details_entity.dart';
import '../models/review_model.dart'; // import your ReviewModel

class PropertyDetailsModel extends PropertyDetailsEntity {
  final List<ReviewModel> reviews; // NEW

  PropertyDetailsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.images,
    required super.beds,
    required super.baths,
    required super.sqft,
    required super.availability,
    required super.status,
    required super.vrTourLink,
    required super.views,
    required super.displayTitle,
    required super.displayDescription,
    required super.amenities,
    this.reviews = const [], // default empty list
  });

  List<String> get fullImageUrls => images.map((img) => img.startsWith('http') ? img : '${AppUrls.baseUrl}$img').toList();

  String get firstImageUrl => fullImageUrls.isNotEmpty ? fullImageUrls[0] : '';

  factory PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['image'] is List) {
      images = (json['image'] as List).map((e) => e.toString()).toList();
    }

    // Parse reviews correctly
    List<ReviewModel> reviews = [];
    if (json['reviews'] != null && json['reviews'] is List) {
      reviews = (json['reviews'] as List)
          .map((r) => ReviewModel.fromJson(r as Map<String, dynamic>))
          .toList();
    }

    return PropertyDetailsModel(
      id: json['_id'] ?? '',
      title: LocalizedTextEntity.fromJson(json['title'] ?? {}),
      description: LocalizedTextEntity.fromJson(json['description'] ?? {}),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      images: images,
      beds: json['beds'] ?? 0,
      baths: json['baths'] ?? 0,
      sqft: json['sqft'] ?? 0,
      availability: json['availability'] ?? '',
      status: json['status'] ?? '',
      vrTourLink: json['vrTourLink'],
      views: (json['views'] as num?)?.toDouble() ?? 0,
      displayTitle: json['displayTitle'] ?? '',
      displayDescription: json['displayDescription'] ?? '',
      amenities: (json['amenities'] as List? ?? [])
          .map((e) => Amenity.fromJson(e))
          .toList(),
      reviews: reviews, // ✅ make sure reviews are included
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title.toJson(),
        'description': description.toJson(),
        'price': price,
        'images': images,
        'beds': beds,
        'baths': baths,
        'sqft': sqft,
        'availability': availability,
        'status': status,
        'vrTourLink': vrTourLink,
        'views': views,
        'displayTitle': displayTitle,
        'displayDescription': displayDescription,
        'amenities': amenities.map((e) => e.toJson()).toList(),
        'reviews': reviews.map((r) => r.toJson()).toList(), // NEW
      };
}
