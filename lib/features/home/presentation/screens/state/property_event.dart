import 'package:equatable/equatable.dart';
import '../../../../listings_screen/widgets/property_filters.dart';
import '../../../../property_details_screen/data/models/add_review_params.dart';

abstract class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object?> get props => [];
}

class FetchProperties extends PropertyEvent {}

class SearchProperties extends PropertyEvent {
  final PropertyFilters filters;
  const SearchProperties({required this.filters});

  @override
  List<Object?> get props => [filters];
}

class TogglePropertyFavorite extends PropertyEvent {
  final String propertyId;

  const TogglePropertyFavorite({required this.propertyId});

  @override
  List<Object?> get props => [propertyId];
}
class FetchPropertyStats extends PropertyEvent {}

