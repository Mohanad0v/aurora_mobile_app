import 'package:equatable/equatable.dart';
import 'localized_text_entity.dart';

class AmenityEntity extends Equatable {
  final String id;
  final LocalizedTextEntity name;

  const AmenityEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class AgentEntity extends Equatable {
  final String id;
  final String name;
  final String email;

  const AgentEntity({required this.id, required this.name, required this.email});

  @override
  List<Object?> get props => [id, name, email];
}

class SellerEntity extends Equatable {
  final String id;
  final String name;
  final String email;

  const SellerEntity({required this.id, required this.name, required this.email});

  @override
  List<Object?> get props => [id, name, email];
}

class PropertyTypeEntity extends Equatable {
  final String id;
  final LocalizedTextEntity typeName;
  final String category;

  const PropertyTypeEntity({required this.id, required this.typeName, required this.category});

  @override
  List<Object?> get props => [id, typeName, category];
}

class CityEntity extends Equatable {
  final String id;
  final LocalizedTextEntity cityName;
  final LocalizedTextEntity country;

  const CityEntity({required this.id, required this.cityName, required this.country});

  @override
  List<Object?> get props => [id, cityName, country];
}

class PropertyEntity extends Equatable {
  final String id;
  final LocalizedTextEntity title;
  final LocalizedTextEntity description;
  final double price;
  final List<String> images;
  final int beds;
  final int baths;
  final int sqft;
  final String availability;
  final String status;
  final String? vrTourLink;
  final List<AmenityEntity> amenities;
  final AgentEntity? agent;
  final SellerEntity? seller;
  final PropertyTypeEntity propertyType;
  final CityEntity city;
  final String mapUrl;
  final int views;
  final String displayTitle;
  final String displayDescription;

  const PropertyEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.beds,
    required this.baths,
    required this.sqft,
    required this.availability,
    required this.status,
    this.vrTourLink,
    required this.amenities,
    this.agent,
    this.seller,
    required this.propertyType,
    required this.city,
    required this.mapUrl,
    required this.views,
    required this.displayTitle,
    required this.displayDescription,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    images,
    beds,
    baths,
    sqft,
    availability,
    status,
    vrTourLink,
    amenities,
    agent,
    seller,
    propertyType,
    city,
    mapUrl,
    views,
    displayTitle,
    displayDescription,
  ];
}

class ReviewerEntity extends Equatable {
  final String id;
  final String name;
  final String email;

  const ReviewerEntity({required this.id, required this.name, required this.email});

  @override
  List<Object?> get props => [id, name, email];
}

class ReviewEntity extends Equatable {
  final String id;
  final int rating;
  final String comment;
  final PropertyEntity property;
  final ReviewerEntity user;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReviewEntity({
    required this.id,
    required this.rating,
    required this.comment,
    required this.property,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, rating, comment, property, user, createdAt, updatedAt];
}
