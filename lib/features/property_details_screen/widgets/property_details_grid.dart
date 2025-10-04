import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/config/theme/src/colors.dart';
import '../data/models/property_details_model.dart';

class PropertyDetailsGrid extends StatelessWidget {
  final PropertyDetailsModel property;

  const PropertyDetailsGrid({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDetailItem(
          icon: Icons.fullscreen,
          label: '${property.sqft ?? 'N/A'} متر مربع',
          title: 'المساحة'.tr(),
        ),
        _buildDetailItem(
          icon: Icons.bed_outlined,
          label: '${property.beds ?? 'N/A'}',
          title: 'bedrooms'.tr(),
        ),
        _buildDetailItem(
          icon: Icons.bathtub_outlined,
          label: '${property.baths ?? 'N/A'}',
          title: 'bathrooms'.tr(),
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String title,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.gray700, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.gray800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }
}
