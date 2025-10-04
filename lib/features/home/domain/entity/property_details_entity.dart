import 'package:aurora_app/features/home/domain/entity/proerty_entity.dart';

import '../../data/models/property_response_model.dart';
import 'localized_text_entity.dart';

class PropertyDetailsEntity {
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
  final double views;
  final String displayTitle;
  final String displayDescription;
  final List<Amenity> amenities;

  PropertyDetailsEntity({
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
    required this.views,
    required this.displayTitle,
    required this.displayDescription,
    required this.amenities,
  });
}
