import 'package:equatable/equatable.dart';
import 'localized_text_entity.dart';

class WishlistPropertyEntity extends Equatable {
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
  final LocalizedTextEntity city;
  final LocalizedTextEntity country;
  final String? vrTourLink;

  const WishlistPropertyEntity({
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
    required this.city,
    required this.country,
    this.vrTourLink,
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
    city,
    country,
    vrTourLink,
  ];
}
