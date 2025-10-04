import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Load favorites for a specific user
class LoadFavorites extends FavoritesEvent {
  final String userId;

  LoadFavorites({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Toggle a property in the favorites list
class ToggleFavorite extends FavoritesEvent {
  final String userId;
  final String propertyId;

  ToggleFavorite({required this.userId, required this.propertyId});

  @override
  List<Object?> get props => [userId, propertyId];
}
