import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/config/theme/src/colors.dart';
import '../../../../../../core/navigation/Routes.dart';
import '../../../../../../core/widgets/image_with_fallback.dart';
import '../../../../../auth/presentation/state/auth_bloc.dart';
import '../../../../data/models/property_response_model.dart';
import '../../../../favorites/presentation/screen/states/favorite_bloc.dart';
import '../../../../favorites/presentation/screen/states/favorite_event.dart';
import '../../../../favorites/presentation/screen/states/favorite_state.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final ValueChanged<String>? onFavorite;

  const PropertyCard({
    super.key,
    required this.property,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1024;

    final cardWidth = isDesktop
        ? screenWidth / 3.2
        : isTablet
            ? screenWidth / 2.1
            : screenWidth * 0.9;

    final userId = _getUserId(context);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.details,
        arguments: property.id,
      ),
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.all(8),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageStack(cardWidth, context, userId),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndType(isTablet),
                  const SizedBox(height: 6),
                  _buildLocation(isTablet),
                  const SizedBox(height: 6),
                  _buildPriceRow(isTablet),
                  const SizedBox(height: 12),
                  _buildFeatureBoxes(isTablet),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getUserId(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    return authState is AuthAuthenticated ? authState.user.id : '';
  }

  Widget _buildImageStack(double cardWidth, BuildContext context, String userId) {
    final imageHeight = cardWidth * 0.55;
    final statusColor = _getStatusColor(property.status);

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: SizedBox(
            height: imageHeight,
            width: double.infinity,
            child: property.firstImageUrl.isNotEmpty
                ? Image.network(
              property.firstImageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                    color: AppColors.auroraBluePrimary,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/image_placeholder.png',
                  fit: BoxFit.cover,
                );
              },
            )
                : Image.asset(
              'assets/images/image_placeholder.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(top: 10, left: 10, child: _buildStatusBadge(statusColor)),
        Positioned(top: 10, right: 10, child: _buildFavoriteButton(context, userId)),
      ],
    );
  }


  Widget _buildFavoriteButton(BuildContext context, String userId) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state is FavoritesLoaded ? context.read<FavoritesBloc>().isFavorite(property.id) : false;

        return GestureDetector(
          onTap: () {
            if (onFavorite != null) {
              onFavorite!(property.id);
            } else if (userId.isNotEmpty) {
              context.read<FavoritesBloc>().add(
                    ToggleFavorite(userId: userId, propertyId: property.id),
                  );
            }
          },
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            radius: 16,
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.error : AppColors.gray700,
              size: 18,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(
        property.status.tr(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return AppColors.success;
      case 'rented':
        return AppColors.info;
      case 'sold':
        return AppColors.error;
      default:
        return AppColors.gray500;
    }
  }

  Widget _buildTitleAndType(bool isTablet) {
    final fontSize = isTablet ? 18.0 : 16.0;
    return Row(
      children: [
        Expanded(
          child: Text(
            property.title.ar,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: AppColors.gray800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 6),
        _propertyTypeBadge(),
      ],
    );
  }

  Widget _propertyTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.auroraBluePrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.home_outlined, size: 14, color: AppColors.auroraBluePrimary),
          const SizedBox(width: 4),
          Text(
            property.propertyType.typeName.ar,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.auroraBluePrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation(bool isTablet) {
    final fontSize = isTablet ? 14.0 : 13.0;
    return Row(
      children: [
        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.gray600),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            property.city.cityName.ar,
            style: TextStyle(fontSize: fontSize, color: AppColors.gray600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(bool isTablet) {
    final fontSize = isTablet ? 20.0 : 18.0;
    final isRent = property.availability.toLowerCase() == 'rent';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isRent ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isRent ? 'rent'.tr() : 'buy'.tr(),
            style: TextStyle(color: isRent ? AppColors.success : AppColors.error, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${property.price} \$',
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: AppColors.auroraBluePrimary),
        ),
      ],
    );
  }

  Widget _buildFeatureBoxes(bool isTablet) {
    final iconSize = isTablet ? 20.0 : 18.0;
    final textSize = isTablet ? 13.0 : 12.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _featureBox(Icons.square_foot, '${property.sqft} متر مربع', iconSize, textSize),
        _featureBox(Icons.bathtub_outlined, '${property.baths} حمام', iconSize, textSize),
        _featureBox(Icons.bed_outlined, '${property.beds} غرفة نوم', iconSize, textSize),
      ],
    );
  }

  Widget _featureBox(IconData icon, String text, double iconSize, double textSize) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: AppColors.gray50, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize, color: AppColors.gray700),
            const SizedBox(height: 4),
            Text(text, style: TextStyle(fontSize: textSize, color: AppColors.gray700), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: AppColors.gray100, blurRadius: 8, spreadRadius: 1, offset: Offset(0, 4)),
      ],
    );
