import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../listings_screen/widgets/property_filters.dart';
import '../../../data/models/property_response_model.dart';
import '../../../data/repo/realestate_repo_impl.dart';
import 'property_event.dart';
import 'property_state.dart';
import 'bloc_status.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final RealEstateRepoImpl realEstateRepoImpl;
  List<Property> _allProperties = [];

  PropertyBloc({required this.realEstateRepoImpl}) : super(const PropertyState()) {
    on<FetchProperties>(_onFetchProperties);
    on<SearchProperties>(_onSearchProperties);
    on<FetchPropertyStats>(_onFetchPropertyStats);
  }

  /// Fetch all properties, then automatically fetch stats
  Future<void> _onFetchProperties(
      FetchProperties event,
      Emitter<PropertyState> emit,
      ) async {
    log('Fetching properties...');
    emit(state.copyWith(propertiesState: BlocStatus.loading()));

    final result = await realEstateRepoImpl.getProperties();

    result.fold(
          (failure) {
        log('Failed to fetch properties: ${failure.message}');
        emit(state.copyWith(propertiesState: BlocStatus.fail(error: failure.message)));
      },
          (properties) {
        _allProperties = properties;
        log('Fetched ${properties.length} properties');

        emit(state.copyWith(
          propertiesState: BlocStatus.success(model: properties),
          totalProperties: properties.length,
        ));

        // Automatically fetch stats after properties
        add(FetchPropertyStats());
      },
    );
  }

  /// Search properties locally
  Future<void> _onSearchProperties(
      SearchProperties event,
      Emitter<PropertyState> emit,
      ) async {
    emit(state.copyWith(propertiesState: BlocStatus.loading()));

    try {
      final filtered = filterProperties(
        properties: _allProperties,
        filters: event.filters,
      );

      emit(state.copyWith(propertiesState: BlocStatus.success(model: filtered)));
    } catch (error) {
      emit(state.copyWith(propertiesState: BlocStatus.fail(error: error.toString())));
    }
  }

  /// Fetch property-related stats (views & completed deals)
  Future<void> _onFetchPropertyStats(
      FetchPropertyStats event,
      Emitter<PropertyState> emit,
      ) async {
    log('Fetching property stats...');

    try {
      // Fetch views
      final viewsResult = await realEstateRepoImpl.getViewsStats();
      final totalViews = viewsResult.fold(
            (failure) {
          log('Failed to get views: ${failure.message}');
          return state.totalViews;
        },
            (response) {
          log('Total views from API: ${response.totalViews}');
          return response.totalViews;
        },
      );

      // Fetch completed deals
      final dealsResult = await realEstateRepoImpl.getCompletedDeals();
      final completedDeals = dealsResult.fold(
            (failure) {
          log('Failed to get completed deals: ${failure.message}');
          return state.completedDeals;
        },
            (count) {
          log('Completed deals from API: $count');
          return count;
        },
      );

      emit(state.copyWith(
        totalViews: totalViews.toInt(),
        completedDeals: completedDeals,
      ));
    } catch (error, stack) {
      log('Error fetching stats: $error', stackTrace: stack);
      emit(state.copyWith(
        totalViews: state.totalViews,
        completedDeals: state.completedDeals,
      ));
    }
  }
}
