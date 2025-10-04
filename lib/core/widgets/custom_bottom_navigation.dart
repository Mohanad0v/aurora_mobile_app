// import 'dart:ui';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../config/theme/src/colors.dart';
// import '../constants/enums.dart';
//
// class BottomNavigation extends StatelessWidget {
//   final Screen currentScreen;
//   final Function(Screen) onNavigate;
//
//   const BottomNavigation({
//     super.key,
//     required this.currentScreen,
//     required this.onNavigate,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: AppColors.white,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.gray100,
//             blurRadius: 8,
//             offset: Offset(0, -2),
//           ),
//         ],
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
//       child: SafeArea(
//         top: false,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildNavItem(context, Icons.home_outlined, Icons.home_filled, 'home'.tr(), Screen.home),
//             _buildNavItem(context, Icons.favorite_border, Icons.favorite, 'favorites'.tr(), Screen.favorites),
//             _buildNavItem(context, Icons.article_outlined, Icons.article, 'blog'.tr(), Screen.blog),
//             _buildNavItem(context, Icons.search_outlined, Icons.search, 'listings'.tr(), Screen.listings),
//             _buildNavItem(context, Icons.person_outline, Icons.person, 'profile'.tr(), Screen.profile),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem(BuildContext context, IconData iconOutline, IconData iconFilled, String label, Screen targetScreen) {
//     final bool isSelected = currentScreen == targetScreen;
//     return GestureDetector(
//       onTap: () => onNavigate(targetScreen),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             isSelected ? iconFilled : iconOutline,
//             color: isSelected ? AppColors.auroraBluePrimary : AppColors.gray500,
//             size: 24,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               color: isSelected ? AppColors.auroraBluePrimary : AppColors.gray500,
//               fontSize: 12,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
