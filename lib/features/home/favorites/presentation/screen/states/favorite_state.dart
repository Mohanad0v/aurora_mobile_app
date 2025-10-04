import 'package:equatable/equatable.dart';

import '../../../../data/models/property_response_model.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Property> properties;
  final List<String> favoritesIds;

  const FavoritesLoaded({
    required this.favoritesIds,
    required this.properties,
  });

  @override
  List<Object> get props => [favoritesIds];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError({required this.message});

  @override
  List<Object> get props => [message];
}
