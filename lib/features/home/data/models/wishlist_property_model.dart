import '../../domain/entity/localized_text_entity.dart';
import '../../domain/entity/wishlist_property_entity.dart';
import 'localized_text_model.dart';

class WishlistPropertyModel extends WishlistPropertyEntity {
  const WishlistPropertyModel({
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
    required super.city,
    required super.country,
    super.vrTourLink,
  });

  factory WishlistPropertyModel.fromJson(Map<String, dynamic> json) {
    return WishlistPropertyModel(
      id: json['_id'] ?? '',
      title: LocalizedTextEntity.fromJson(json['title'] ?? {}),
      description: LocalizedTextEntity.fromJson(json['description'] ?? {}),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      images: List<String>.from(json['image'] ?? []),
      beds: json['beds'] ?? 0,
      baths: json['baths'] ?? 0,
      sqft: json['sqft'] ?? 0,
      availability: json['availability'] ?? '',
      status: json['status'] ?? '',
      city: LocalizedTextEntity.fromJson(json['city']?['city_name'] ?? {}),
      country: LocalizedTextEntity.fromJson(json['city']?['country'] ?? {}),
      vrTourLink: json['vrTourLink'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title.toJson(),
    'description': description.toJson(),
    'price': price,
    'image': images,
    'beds': beds,
    'baths': baths,
    'sqft': sqft,
    'availability': availability,
    'status': status,
    'city': {
      'city_name': city.toJson(),
      'country': country.toJson(),
    },
        'vrTourLink': vrTourLink,
  };
}
