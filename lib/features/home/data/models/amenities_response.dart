import 'package:aurora_app/features/home/data/models/property_response_model.dart';

class AmenitiesResponse {
  final List<Amenity> amenities;
  final bool success;

  AmenitiesResponse({
    required this.amenities,
    required this.success,
  });

  factory AmenitiesResponse.fromJson(Map<String, dynamic> json) {
    return AmenitiesResponse(
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => Amenity.fromJson(e))
          .toList() ??
          [],
      success: json['success'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amenities': amenities.map((e) => e.toJson()).toList(),
      'success': success,
    };
  }
}