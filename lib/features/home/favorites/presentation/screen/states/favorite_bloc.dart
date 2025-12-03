import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repo/realestate_repo_impl.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';
import '../../../../data/models/property_response_model.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final RealEstateRepoImpl repo;
  final List<String> _favoritesIds = [];
  final List<Property> _properties = [];

  FavoritesBloc({required this.repo}) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());

    final result = await repo.getWishlist(event.userId);

    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (properties) {
        _properties
          ..clear()
          ..addAll(properties);
        _favoritesIds
          ..clear()
          ..addAll(properties.map((p) => p.id));

        emit(FavoritesLoaded(
          favoritesIds: List.unmodifiable(_favoritesIds),
          properties: List.unmodifiable(_properties),
        ));
      },
    );
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<FavoritesState> emit) async {
    if (state is! FavoritesLoaded) return;

    final propertyId = event.propertyId;
    final isCurrentlyFavorite = _favoritesIds.contains(propertyId);

    if (isCurrentlyFavorite) {
      _favoritesIds.remove(propertyId);
    } else {
      _favoritesIds.add(propertyId);
    }

    emit(FavoritesLoaded(
      favoritesIds: List.unmodifiable(_favoritesIds),
      properties: List.unmodifiable(_properties),
    ));

    try {
      if (isCurrentlyFavorite) {
        await repo.removeFromWishlist(event.userId, propertyId);
      } else {
        await repo.addToWishlist(event.userId, propertyId);
      }
    } catch (e) {
      if (isCurrentlyFavorite) {
        _favoritesIds.add(propertyId);
      } else {
        _favoritesIds.remove(propertyId);
      }

      emit(FavoritesLoaded(
        favoritesIds: List.unmodifiable(_favoritesIds),
        properties: List.unmodifiable(_properties),
      ));
      emit(FavoritesError(message: e.toString()));
    }
  }

  bool isFavorite(String propertyId) => _favoritesIds.contains(propertyId);

  List<String> get favoritesIds => List.unmodifiable(_favoritesIds);

  List<Property> get properties => List.unmodifiable(_properties);
}
