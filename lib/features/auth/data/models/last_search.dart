class LastSearch {
  final String minPrice;
  final String maxPrice;
  final int bedrooms;
  final int bathrooms;
  final int area;
  final String city;
  final String searchQuery;
  final String availability;
  final String sortBy;
  final String status;
  final List<String> amenities;
  final String? propertyType;

  LastSearch({
    required this.minPrice,
    required this.maxPrice,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.city,
    required this.searchQuery,
    required this.availability,
    required this.sortBy,
    required this.status,
    required this.amenities,
    this.propertyType,
  });

  factory LastSearch.fromJson(Map<String, dynamic> json) {
    return LastSearch(
      minPrice: json['minPrice'] ?? '',
      maxPrice: json['maxPrice'] ?? '',
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      area: json['area'] ?? 0,
      city: json['city'] ?? '',
      searchQuery: json['searchQuery'] ?? '',
      availability: json['availability'] ?? '',
      sortBy: json['sortBy'] ?? '',
      status: json['status'] ?? '',
      amenities: (json['amenities'] as List<dynamic>?)?.cast<String>() ?? [],
      propertyType: json['propertyType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'city': city,
      'searchQuery': searchQuery,
      'availability': availability,
      'sortBy': sortBy,
      'status': status,
      'amenities': amenities,
      'propertyType': propertyType,
    };
  }
}
