import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../data/models/property_response_model.dart';
import '../../../../property_details_screen/data/models/review_model.dart';
import 'bloc_status.dart';

@immutable
class PropertyState extends Equatable {
  final BlocStatus<List<Property>> propertiesState;
  final BlocStatus<List<Property>> togglePropertyFavorite;

  final int totalProperties;
  final int completedDeals;
  final int totalViews;

  const PropertyState({
    this.propertiesState = const BlocStatus(),
    this.togglePropertyFavorite = const BlocStatus(),
    this.totalProperties = 0,
    this.completedDeals = 0,
    this.totalViews = 0,
  });

  PropertyState copyWith({
    BlocStatus<List<Property>>? propertiesState,
    BlocStatus<List<Property>>? togglePropertyFavorite,
    int? totalProperties,
    int? completedDeals,
    int? totalViews,
  }) {
    return PropertyState(
      propertiesState: propertiesState ?? this.propertiesState,
      togglePropertyFavorite: togglePropertyFavorite ?? this.togglePropertyFavorite,
      totalProperties: totalProperties ?? this.totalProperties,
      completedDeals: completedDeals ?? this.completedDeals,
      totalViews: totalViews ?? this.totalViews,
    );
  }

  @override
  List<Object?> get props => [
    propertiesState,
    togglePropertyFavorite,
    totalProperties,
    completedDeals,
    totalViews,
  ];
}
