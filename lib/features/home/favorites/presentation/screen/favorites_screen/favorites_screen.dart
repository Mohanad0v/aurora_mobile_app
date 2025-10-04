import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/config/theme/src/colors.dart';
import '../../../../../../core/injection/injection.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../auth/presentation/state/auth_bloc.dart';
import '../../../../data/models/property_response_model.dart';
import '../../../../presentation/screens/home_screen/widgets/property_card.dart';
import '../states/favorite_bloc.dart';
import '../states/favorite_event.dart';
import '../states/favorite_state.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final String _userId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    _userId = authState is AuthAuthenticated ? authState.user.id : '';

    // Load favorites once
    context.read<FavoritesBloc>().add(LoadFavorites(userId: _userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator<FavoritesBloc>(), // Use the shared FavoritesBloc
      child: Scaffold(
        backgroundColor: AppColors.gray50,
        appBar: AppBar(
          title: Text('favorites'.tr()),
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.gray800,
          elevation: 1,
        ),
        body: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FavoritesError) {
              return _buildErrorState(context, state.message);
            }

            if (state is FavoritesLoaded) {
              final favorites = state.properties
                  .where((p) => state.favoritesIds.contains(p.id))
                  .toList(growable: false);

              if (favorites.isEmpty) return _buildEmptyState();

              return _buildFavoritesList(favorites, context);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${'failedToFetchProperties'.tr()} $message',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'retry'.tr(),
            onPressed: () =>
                context.read<FavoritesBloc>().add(LoadFavorites(userId: _userId)),
            gradient: AppColors.auroraGradientPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'noFavorites'.tr(),
        style: const TextStyle(fontSize: 18, color: AppColors.gray600),
      ),
    );
  }

  Widget _buildFavoritesList(List<Property> favorites, BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final property = favorites[index];
        return PropertyCard(
          property: property,
          onFavorite: (id) {
            context
                .read<FavoritesBloc>()
                .add(ToggleFavorite(userId: _userId, propertyId: id));
          },
        );
      },
    );
  }
}
