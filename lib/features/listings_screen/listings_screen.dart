import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/config/theme/src/colors.dart';
import '../../../../../core/injection/injection.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../core/widgets/filter_drawer.dart';
import '../auth/presentation/state/auth_bloc.dart';
import '../home/favorites/presentation/screen/states/favorite_bloc.dart';
import '../home/favorites/presentation/screen/states/favorite_event.dart';
import '../home/favorites/presentation/screen/states/favorite_state.dart';
import '../home/presentation/screens/home_screen/widgets/property_card.dart';
import '../home/presentation/screens/state/property_bloc.dart';
import '../home/presentation/screens/state/property_event.dart';
import '../home/presentation/screens/state/property_state.dart';
import '../../features/listings_screen/widgets/property_filters.dart';

class PropertyListingsScreen extends StatefulWidget {
  const PropertyListingsScreen({super.key});

  @override
  State<PropertyListingsScreen> createState() => _PropertyListingsScreenState();
}

class _PropertyListingsScreenState extends State<PropertyListingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final NavigationService _navigationService = locator<NavigationService>();

  late PropertyFilters _filters;
  late String _userId;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _filters = PropertyFilters();

    final authState = context.read<AuthBloc>().state;
    _userId = authState is AuthAuthenticated ? authState.user.id : '';

    context.read<FavoritesBloc>().add(LoadFavorites(userId: _userId));

    context.read<PropertyBloc>().add(FetchProperties());
  }

  void _applyFilters(PropertyFilters filters) {
    setState(() => _filters = filters);
    _searchController.text = filters.searchQuery ?? '';

    context.read<PropertyBloc>().add(SearchProperties(filters: filters));
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final normalizedValue = value.trim().isEmpty ? null : normalizeArabic(value.trim());

      final updatedFilters = _filters.copyWith(
        searchQuery: normalizedValue,
      );

      _applyFilters(updatedFilters);
    });
  }


  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<PropertyBloc>()),
        BlocProvider.value(value: context.read<FavoritesBloc>()),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.gray50,
        endDrawer: FilterDrawer(
          currentFilters: _filters,
          onApplyFilters: (filters) {
            _applyFilters(filters);
            _scaffoldKey.currentState?.closeEndDrawer();
          },
          onResetFilters: () {
            setState(() {
              _filters = PropertyFilters();
              _searchController.clear();
            });
            _scaffoldKey.currentState?.closeEndDrawer();
            context.read<PropertyBloc>().add(SearchProperties(filters: PropertyFilters()));
          },
        ),
        body: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildPropertyList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(color: AppColors.gray100, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48),
                Text(
                  'propertyListings'.tr(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.gray800),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    textDirection: ui.TextDirection.rtl,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    controller: _searchController,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: AppColors.gray700),
                    onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyList() {
    return BlocBuilder<PropertyBloc, PropertyState>(
      builder: (context, state) {
        final properties = state.propertiesState.model ?? [];

        if (state.propertiesState.isLoading()) return const Center(child: CircularProgressIndicator());
        if (state.propertiesState.isFail()) return _buildErrorState(state.propertiesState.error);
        if (properties.isEmpty) return Center(child: Text('noPropertiesFound'.tr()));

        return BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, favState) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];
                return PropertyCard(
                  property: property,
                  onFavorite: (id) => context.read<FavoritesBloc>().add(ToggleFavorite(userId: _userId, propertyId: id)),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildErrorState(String? error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${'failedToFetchProperties'.tr()} $error', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<PropertyBloc>().add(SearchProperties(filters: _filters)),
              child: Text('retry'.tr()),
            ),
          ],
        ),
      );
}
