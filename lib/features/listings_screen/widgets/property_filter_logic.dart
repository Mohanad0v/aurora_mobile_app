// lib/core/utils/property_filter_logic.dart

import 'package:aurora_app/features/listings_screen/widgets/property_filters.dart';

import '../../home/data/models/property_response_model.dart';

/// Normalizes Arabic text to handle different character forms.
String _normalizeArabic(String text) {
  return text
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ؤ', 'و')
      .replaceAll('ئ', 'ي')
      .replaceAll('ة', 'ه');
}

/// Checks if a query string matches either English or Arabic text fields.
bool _matchesText(
  String? textEn,
  String? textAr,
  String? query,
) {
  if (query == null || query.trim().isEmpty) return true;

  final normalizedQuery = _normalizeArabic(query.trim().toLowerCase());

  final enMatch = _normalizeArabic(textEn ?? '').toLowerCase().contains(normalizedQuery);

  final arMatch = _normalizeArabic(textAr ?? '').toLowerCase().contains(normalizedQuery);

  return enMatch || arMatch;
}

/// Main function to filter a list of properties based on various criteria.
List<Property> filterProperties({
  required List<Property> properties,
  required PropertyFilters filters,
}) {
  return properties.where((property) {
    // Check if the property is available based on filter
    final availabilityMatch = filters.availability == null ||
        filters.availability!.isEmpty ||
        filters.availability!.toLowerCase() == 'all' ||
        property.availability.toLowerCase() == filters.availability!.toLowerCase();

    // Check if the property type matches the filter
    final typeMatch = filters.propertyType == null ||
        filters.propertyType!.isEmpty ||
        filters.propertyType!.toLowerCase() == 'all' ||
        _matchesText(
          property.propertyType.typeName.en,
          property.propertyType.typeName.ar,
          filters.propertyType,
        );

    // Check if the price is within the specified range
    final priceMatch =
        (filters.minPrice == null || property.price >= filters.minPrice!) && (filters.maxPrice == null || property.price <= filters.maxPrice!);

    // Check if the number of bedrooms matches
    final bedroomsMatch = filters.bedrooms == null || (filters.bedrooms! >= 5 ? property.beds >= 5 : property.beds == filters.bedrooms);

    // Check if the number of bathrooms matches
    final bathroomsMatch = filters.bathrooms == null || (filters.bathrooms! >= 4 ? property.baths >= 4 : property.baths == filters.bathrooms);

    // Check if all selected amenities are present in the property
    final amenitiesMatch = filters.amenities.isEmpty ||
        filters.amenities.every((filterAmenity) => property.amenities.any(
              (amenity) => _matchesText(amenity.name.en, amenity.name.ar, filterAmenity),
            ));

    // Check if the search query matches title, description, or city
    final queryMatch = (filters.searchQuery == null || filters.searchQuery!.isEmpty) ||
        _matchesText(property.displayTitle, property.displayTitle, filters.searchQuery) ||
        _matchesText(property.displayDescription, property.displayDescription, filters.searchQuery) ||
        _matchesText(property.city.cityName.en, property.city.cityName.ar, filters.searchQuery);

    return availabilityMatch && typeMatch && priceMatch && bedroomsMatch && bathroomsMatch && amenitiesMatch && queryMatch;
  }).toList();
}
