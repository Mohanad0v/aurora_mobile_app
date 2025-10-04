import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/config/theme/src/colors.dart';
import '../../../../../../core/constants/enums.dart';
import '../../../../../../core/widgets/logo_widget.dart';

class AppHeader extends StatelessWidget {
  final Function(Screen, {Map<String, dynamic>? data}) onNavigate;
  final Animation<double> opacityAnimation;

  const AppHeader({
    super.key,
    required this.onNavigate,
    required this.opacityAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: const BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.gray100,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: AppColors.gray700, size: 24),
                onPressed: () {},
              ),
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      gradient: AppColors.blueToPurpleGradient,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: const Center(
                      child: LogoWidget(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'appTitle'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray800,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.article_outlined, color: AppColors.gray700, size: 24),
                    onPressed: () => onNavigate(Screen.blog),
                    tooltip: 'blog'.tr(),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: AppColors.gray700, size: 24),
                        onPressed: () {},
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline, color: AppColors.gray700, size: 24),
                    onPressed: () {
                      onNavigate(Screen.profile);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}