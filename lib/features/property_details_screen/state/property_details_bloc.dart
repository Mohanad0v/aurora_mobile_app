import 'package:aurora_app/features/property_details_screen/state/property_details_event.dart';
import 'package:aurora_app/features/property_details_screen/state/property_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/domain/repositories/realestate_repository.dart';
import '../data/models/review_model.dart';

class PropertyDetailsBloc extends Bloc<PropertyDetailsEvent, PropertyDetailsState> {
  final RealEstateRepository repository;

  PropertyDetailsBloc({required this.repository}) : super(const PropertyDetailsState()) {
    on<FetchPropertyDetails>(_onFetchPropertyDetails);
    on<FetchPropertyReviews>(_onFetchPropertyReviews);
    on<AddPropertyReview>(_onAddPropertyReview);
  }

  Future<void> _onFetchPropertyDetails(
      FetchPropertyDetails event,
      Emitter<PropertyDetailsState> emit,
      ) async {
    emit(state.copyWith(isLoadingDetails: true, error: null));

    final result = await repository.getPropertyDetailsById(event.propertyId);

    result.fold(
          (failure) => emit(state.copyWith(isLoadingDetails: false, error: failure.message)),
          (details) => emit(state.copyWith(isLoadingDetails: false, propertyDetails: details)),
    );
  }

  Future<void> _onFetchPropertyReviews(
      FetchPropertyReviews event,
      Emitter<PropertyDetailsState> emit,
      ) async {
    emit(state.copyWith(isLoadingReviews: true, error: null));

    final result = await repository.getReviews(event.propertyId);

    result.fold(
          (failure) => emit(state.copyWith(isLoadingReviews: false, error: failure.message)),
          (reviews) => emit(state.copyWith(isLoadingReviews: false, reviews: reviews)),
    );
  }

  Future<void> _onAddPropertyReview(
      AddPropertyReview event,
      Emitter<PropertyDetailsState> emit,
      ) async {
    emit(state.copyWith(isAddingReview: true, error: null));

    final result = await repository.addReview(event.params);

    result.fold(
          (failure) {
        emit(state.copyWith(isAddingReview: false, error: failure.message));
      },
          (review) {
        final updatedReviews = List<ReviewModel>.from(state.reviews);
        if (review != null) {
          updatedReviews.add(review);
        }

        emit(state.copyWith(
          isAddingReview: false,
          reviews: updatedReviews,
        ));
      },
    );
  }
}
