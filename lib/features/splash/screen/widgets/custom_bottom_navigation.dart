import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/theme/src/colors.dart';
import '../../../../core/constants/enums.dart';

class CustomBottomNavigation extends StatelessWidget {
  final Screen currentScreen;
  final void Function(Screen) onNavigate;

  const CustomBottomNavigation({
    super.key,
    required this.currentScreen,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.gray100,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              iconOutline: Icons.home_outlined,
              iconFilled: Icons.home,
              label: 'Home'.tr(),
              targetScreen: Screen.home,
            ),
            _buildNavItem(
              context,
              iconOutline: Icons.favorite_border_outlined,
              iconFilled: Icons.favorite,
              label: 'Favorites'.tr(),
              targetScreen: Screen.favorites,
            ),
            _buildNavItem(
              context,
              iconOutline: Icons.newspaper_outlined,
              iconFilled: Icons.newspaper,
              label: 'Blog'.tr(),
              targetScreen: Screen.blog,
            ),
            _buildNavItem(
              context,
              iconOutline: Icons.list_alt_outlined,
              iconFilled: Icons.list_alt,
              label: 'Properties'.tr(),
              targetScreen: Screen.listings,
            ),
            _buildNavItem(
              context,
              iconOutline: Icons.person_outline_outlined,
              iconFilled: Icons.person,
              label: 'Profile'.tr(),
              targetScreen: Screen.profile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required IconData iconOutline,
        required IconData iconFilled,
        required String label,
        required Screen targetScreen,
      }) {
    final bool isSelected = currentScreen == targetScreen;

    return GestureDetector(
      onTap: () => onNavigate(targetScreen),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Icon(
                isSelected ? iconFilled : iconOutline,
                color: isSelected ? AppColors.auroraBluePrimary : AppColors.gray500,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              style: TextStyle(
                color: isSelected ? AppColors.auroraBluePrimary : AppColors.gray500,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
