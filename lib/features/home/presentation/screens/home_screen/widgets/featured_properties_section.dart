import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/config/theme/src/colors.dart';
import '../../../../../../core/helper_functions/dialog_utils.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../core/injection/injection.dart';
import '../../../../../../core/navigation/Routes.dart';
import '../../../../../../core/navigation/navigation_service.dart';
import '../../../../../auth/presentation/state/auth_bloc.dart';
import '../../../../favorites/presentation/screen/states/favorite_state.dart';
import '../../state/property_bloc.dart';
import '../../state/property_event.dart';
import '../../state/property_state.dart';
import '../../../../favorites/presentation/screen/states/favorite_bloc.dart';
import '../../../../favorites/presentation/screen/states/favorite_event.dart';
import 'property_card.dart';

class FeaturedPropertiesSection extends StatelessWidget {
  final VoidCallback onViewAllPressed;
  const FeaturedPropertiesSection({super.key, required this.onViewAllPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final authState = context.read<AuthBloc>().state;
    final userId = authState is AuthAuthenticated ? authState.user.id : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildHeader(context, screenWidth),
          const SizedBox(height: 16),
          BlocConsumer<PropertyBloc, PropertyState>(
            listener: (context, state) {
              if (state.propertiesState.isFail()) {
                DialogUtils.showAlertDialog(
                  context,
                  title: 'authenticationError'.tr(),
                  message: state.propertiesState.error ?? 'unknownError'.tr(),
                );
              }
            },
            builder: (context, state) {
              final properties = state.propertiesState.model ?? [];

              if (state.propertiesState.isLoading()) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.propertiesState.isFail()) {
                return _buildErrorState(context, state.propertiesState.error ?? 'unknownError'.tr());
              }
              if (properties.isEmpty) {
                return Center(child: Text('noMatchingProperties'.tr()));
              }

              return BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, favState) {
                  final favoriteIds = favState is FavoritesLoaded ? favState.favoritesIds : <String>[];
                  final featured = properties
                      .where((p) => favoriteIds.contains(p.id) || (p.views ?? 0) > 200)
                      .take(3)
                      .toList();

                  if (featured.isEmpty) return Center(child: Text('noMatchingProperties'.tr()));

                  return Column(
                    children: featured.map((property) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: PropertyCard(
                          property: property,
                          onFavorite: (id) {
                            if (userId.isNotEmpty) {
                              context.read<FavoritesBloc>().add(
                                ToggleFavorite(userId: userId, propertyId: id),
                              );
                            }
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'featuredProperties'.tr(),
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: AppColors.gray800,
          ),
        ),
        TextButton(
          onPressed: onViewAllPressed,
          child: Text(
            'viewAll'.tr(),
            style: const TextStyle(color: AppColors.auroraBluePrimary),
          ),
        ),
      ],
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
          const SizedBox(height: 8),
          CustomButton(
            text: 'retry'.tr(),
            onPressed: () => context.read<PropertyBloc>().add(FetchProperties()),
            gradient: AppColors.auroraGradientPrimary,
          ),
        ],
      ),
    );
  }
}

