import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/config/theme/src/colors.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../core/widgets/custom_input_field.dart';

class HeaderSection extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedPropertyType;
  final Function(String) onPropertyTypeSelected;
  final VoidCallback onSearchPressed;
  final ValueChanged<String> onSearchTextChanged;

  const HeaderSection({
    super.key,
    required this.searchController,
    required this.selectedPropertyType,
    required this.onPropertyTypeSelected,
    required this.onSearchPressed,
    required this.onSearchTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'findYourDreamProperty'.tr(),
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'discoverPerfectHome'.tr(),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: AppColors.gray600,
                ),
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: searchController,
                hintText: 'searchByCityTypeLocation'.tr(),
                prefixIcon: Icons.search,
                onChanged: onSearchTextChanged,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'searchProperties'.tr(),
                onPressed: onSearchPressed,
                gradient: AppColors.auroraGradientPrimary,
                icon: Icons.search,
                height: 48,
              ),
            ],
          ),
        );
      },
    );
  }
}
