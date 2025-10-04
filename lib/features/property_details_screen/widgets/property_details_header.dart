import 'package:aurora_app/features/property_details_screen/widgets/property_details_grid.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/config/theme/src/colors.dart';
import '../data/models/property_details_model.dart';

class PropertyDetailsHeader extends StatelessWidget {
  final PropertyDetailsModel property;
  final VoidCallback onSchedulePressed;

  const PropertyDetailsHeader({
    super.key,
    required this.property,
    required this.onSchedulePressed,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(property.status);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title, Price & Type
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title.getLocalized(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${property.price} \$',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.auroraBluePrimary,
                    ),
                  ),
                ],
              ),
            ),
            // Status Badge
            _buildStatusBadge(statusColor),
          ],
        ),
        const SizedBox(height: 16),
        // Description
        Text(
          property.description?.getLocalized() ?? 'noDescriptionAvailable'.tr(),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.gray600,
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 24),
        // Details Grid
        PropertyDetailsGrid(property: property),
        const SizedBox(height: 24),
        // Amenities Section
        if (property.amenities != null && property.amenities!.isNotEmpty) ...[
          Text(
            'المرافق'.tr(), // "Amenities"
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.gray800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: property.amenities!.map((amenity) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.auroraBluePrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  amenity.name.ar,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.auroraBluePrimary,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
        // Schedule Visit Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onSchedulePressed,
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text('جدولة موعد لزيارة العقار'.tr()),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: AppColors.auroraBluePrimary,
              foregroundColor: AppColors.white,
              elevation: 0,
            ),
          ),
        ),
      ],
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
}
