class StringHelpers {
  const StringHelpers._();

  static String getStatusKey(String status) {
    switch (status) {
      case 'Available':
        return 'available';
      case 'Rented':
        return 'rented';
      case 'Sold':
        return 'sold';
      default:
        return status;
    }
  }

  static String getPropertyTypeKey(String type) {
    switch (type) {
      case 'All':
        return 'all';
      case 'Apartment':
        return 'apartment';
      case 'Villa':
        return 'villa';
      case 'Office':
        return 'office';
      case 'Shop':
        return 'shop';
      default:
        return 'all';
    }
  }

  static String getAmenityKey(String amenity) {
    switch (amenity) {
      case 'Pool':
        return 'pool';
      case 'Parking':
        return 'parking';
      case 'Gym':
        return 'gym';
      case 'Security':
        return 'security';
      case 'Balcony':
        return 'balcony';
      case 'Private Beach Access':
        return 'privateBeachAccess';
      case 'Air Conditioning':
        return 'airConditioning';
      case 'Concierge':
        return 'concierge';
      default:
        return amenity;
    }
  }
}