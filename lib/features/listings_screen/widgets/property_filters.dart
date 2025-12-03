import '../../home/data/models/property_response_model.dart';

// lib/features/listings_screen/widgets/property_filters.dart
import '../../home/data/models/property_response_model.dart';

class PropertyFilters {
  final String? searchQuery;
  final String? city;
  final String? propertyType;
  final double? minPrice;
  final double? maxPrice;
  final int? bedrooms;
  final int? bathrooms;

  final Set<String> amenities;
  final String? availability;

  const PropertyFilters({
    this.searchQuery,
    this.city,
    this.propertyType,
    this.minPrice,
    this.maxPrice,
    this.bedrooms,
    this.bathrooms,
    this.amenities = const <String>{},
    this.availability,
  });

  PropertyFilters copyWith({
    String? searchQuery,
    String? city,
    String? propertyType,
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
    int? bathrooms,
    Set<String>? amenities,
    String? availability,
  }) {
    return PropertyFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      city: city ?? this.city,
      propertyType: propertyType ?? this.propertyType,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      amenities: amenities ?? this.amenities,
      availability: availability ?? this.availability,
    );
  }
}

String normalizeArabic(String text) {
  return text
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ؤ', 'و')
      .replaceAll('ئ', 'ي')
      .replaceAll('ة', 'ه');
}

bool matchesText(String? textEn, String? textAr, String? query) {
  if (query == null || query.trim().isEmpty) return true;

  final q = query.trim().toLowerCase();
  final normalizedQ = normalizeArabic(q);

  final en = (textEn ?? '').toLowerCase();
  final ar = normalizeArabic(textAr ?? '').toLowerCase();

  return en.contains(q) || ar.contains(normalizedQ);
}


bool propertyTypeMatches(Property property, String? filterType) {
  if (filterType == null || filterType.isEmpty || filterType.toLowerCase() == 'all') return true;
  final typeEn = property.propertyType.typeName.en.toLowerCase();
  final typeAr = property.propertyType.typeName.ar;
  return typeEn == filterType.toLowerCase() || typeAr == filterType;
}

bool availabilityMatches(Property property, String? filterAvailability) {
  if (filterAvailability == null || filterAvailability.isEmpty || filterAvailability.toLowerCase() == 'all') return true;
  final normalized = filterAvailability.toLowerCase();
  return property.availability.toLowerCase() == normalized || property.status.toLowerCase() == normalized;
}

bool bedroomsMatch(Property property, int? filterBeds) {
  if (filterBeds == null) return true;
  return filterBeds >= 5 ? property.beds >= 5 : property.beds == filterBeds;
}

bool bathroomsMatch(Property property, int? filterBaths) {
  if (filterBaths == null) return true;
  return filterBaths >= 4 ? property.baths >= 4 : property.baths == filterBaths;
}

bool amenitiesMatch(Property property, List<String> filterAmenities) {
  if (filterAmenities.isEmpty) return true;
  return filterAmenities.every((filterAmenity) =>
      property.amenities.any((amenity) => amenity.name.en.toLowerCase() == filterAmenity.toLowerCase() || amenity.name.ar == filterAmenity));
}

List<Property> filterProperties({
  required List<Property> properties,
  required PropertyFilters filters,
}) {
  return properties.where((property) {
    final queryMatch = matchesText(
      property.title?.en,
      property.title?.ar,
      filters.searchQuery,
    ) || matchesText(
      property.description?.en,
      property.description?.ar,
      filters.searchQuery,
    );

    final cityMatch = filters.city == null || filters.city!.isEmpty ||
        matchesText(
          property.city.cityName.en,
          property.city.cityName.ar,
          filters.city,
        );

    final amenitiesMatchResult = filters.amenities.isEmpty
        ? true
        : filters.amenities.every((filterAmenity) =>
        property.amenities.any((amenity) =>
        normalizeArabic(amenity.name.en.toLowerCase()) ==
            normalizeArabic(filterAmenity.toLowerCase()) ||
            normalizeArabic(amenity.name.ar) ==
                normalizeArabic(filterAmenity)));

    return queryMatch &&
        cityMatch &&
        propertyTypeMatches(property, filters.propertyType) &&
        availabilityMatches(property, filters.availability) &&
        (filters.minPrice == null || property.price >= filters.minPrice!) &&
        (filters.maxPrice == null || property.price <= filters.maxPrice!) &&
        bedroomsMatch(property, filters.bedrooms) &&
        bathroomsMatch(property, filters.bathrooms) &&
        amenitiesMatchResult;
  }).toList();
}

