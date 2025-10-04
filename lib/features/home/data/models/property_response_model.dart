import 'package:aurora_app/core/constants/app_url/app_url_strings.dart';
import '../../domain/entity/localized_text_entity.dart';
import '../../domain/entity/proerty_entity.dart';
import 'localized_text_model.dart';
import '../../../property_details_screen/data/models/review_model.dart';

class PropertyResponse {
  final List<Property> property;
  final bool success;

  PropertyResponse({required this.property, required this.success});

  factory PropertyResponse.fromJson(Map<String, dynamic> json) {
    return PropertyResponse(
      property: (json['property'] as List<dynamic>?)?.map((e) => Property.fromJson(e ?? {})).toList() ?? [],
      success: json['success'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'property': property.map((e) => e.toJson()).toList(),
        'success': success,
      };
}

class Property extends PropertyEntity {
  Property({
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
    required super.amenities,
    super.agent,
    super.seller,
    required super.propertyType,
    required super.city,
    required super.mapUrl,
    required super.views,
    required super.displayTitle,
    required super.displayDescription,
  });

  List<String> get fullImageUrls => images.map((img) => img.startsWith('http') ? img : '${AppUrls.baseUrl}$img').toList();

  String get firstImageUrl => fullImageUrls.isNotEmpty ? fullImageUrls[0] : '';

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['_id']?.toString() ?? '',
      title: LocalizedTextEntity.fromJson(json['title'] ?? {}),
      description: LocalizedTextEntity.fromJson(json['description'] ?? {}),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      images: (json['image'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      beds: (json['beds'] as num?)?.toInt() ?? 0,
      baths: (json['baths'] as num?)?.toInt() ?? 0,
      sqft: (json['sqft'] as num?)?.toInt() ?? 0,
      availability: json['availability']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      vrTourLink: json['vrTourLink']?.toString(),
      amenities:
          (json['amenities'] as List<dynamic>? ?? []).map((e) => AmenityEntity(id: e['_id'], name: LocalizedTextEntity.fromJson(e['name']))).toList(),
      agent: json['agent'] != null
          ? AgentEntity(
              id: json['agent']['_id'] ?? '',
              name: json['agent']['name'] ?? '',
              email: json['agent']['email'] ?? '',
            )
          : null,
      seller: json['seller'] != null
          ? SellerEntity(
              id: json['seller']['_id'] ?? '',
              name: json['seller']['name'] ?? '',
              email: json['seller']['email'] ?? '',
            )
          : null,
      propertyType: PropertyTypeEntity(
        id: json['propertyType']?['_id'] ?? '',
        typeName: LocalizedTextEntity.fromJson(json['propertyType']?['type_name'] ?? {}),
        category: json['propertyType']?['category'] ?? '',
      ),
      city: CityEntity(
        id: json['city']?['_id'] ?? '',
        cityName: LocalizedTextEntity.fromJson(json['city']?['city_name'] ?? {}),
        country: LocalizedTextEntity.fromJson(json['city']?['country'] ?? {}),
      ),
      mapUrl: json['mapUrl'] ?? '',
      views: (json['views'] as num?)?.toInt() ?? 0,
      displayTitle: json['displayTitle'] ?? '',
      displayDescription: json['displayDescription'] ?? '',
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
        'vrTourLink': vrTourLink,
        'amenities': amenities.map((e) => {'_id': e.id, 'name': e.name.toJson()}).toList(),
        'agent': agent != null ? {'_id': agent!.id, 'name': agent!.name, 'email': agent!.email} : null,
        'seller': seller != null ? {'_id': seller!.id, 'name': seller!.name, 'email': seller!.email} : null,
        'propertyType': {
          '_id': propertyType.id,
          'type_name': propertyType.typeName.toJson(),
          'category': propertyType.category,
        },
        'city': {
          '_id': city.id,
          'city_name': city.cityName.toJson(),
          'country': city.country.toJson(),
        },
        'mapUrl': mapUrl,
        'views': views,
        'displayTitle': displayTitle,
        'displayDescription': displayDescription,
      };
}

// ----------------- Other Classes -----------------

class Amenity {
  final String id;
  final LocalizedText name;

  Amenity({required this.id, required this.name});

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      id: json['_id']?.toString() ?? '',
      name: LocalizedText.fromJson(json['name'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name.toJson()};
}

class Agent {
  final String id;
  final String name;
  final String email;

  Agent({required this.id, required this.name, required this.email});

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'email': email};
}

class Seller {
  final String id;
  final String name;
  final String email;

  Seller({required this.id, required this.name, required this.email});

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'email': email};
}

class PropertyType {
  final String id;
  final LocalizedText typeName;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  PropertyType({
    required this.id,
    required this.typeName,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyType.fromJson(Map<String, dynamic> json) {
    return PropertyType(
      id: json['_id']?.toString() ?? '',
      typeName: LocalizedText.fromJson(json['type_name'] ?? {}),
      category: json['category']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  static PropertyType defaultInstance() => PropertyType(
        id: '',
        typeName: LocalizedText(en: '', ar: ''),
        category: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'type_name': typeName.toJson(),
        'category': category,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class City {
  final String id;
  final LocalizedText cityName;
  final LocalizedText country;

  City({required this.id, required this.cityName, required this.country});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['_id']?.toString() ?? '',
      cityName: LocalizedText.fromJson(json['city_name'] ?? {}),
      country: LocalizedText.fromJson(json['country'] ?? {}),
    );
  }

  static City defaultInstance() => City(
        id: '',
        cityName: LocalizedText(en: '', ar: ''),
        country: LocalizedText(en: '', ar: ''),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'city_name': cityName.toJson(),
        'country': country.toJson(),
      };
}
