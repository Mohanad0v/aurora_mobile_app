import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/config/theme/src/colors.dart';
import '../../../../core/widgets/logo_widget.dart';

class AuthHeader extends StatelessWidget {
  final bool isSignUp;
  final double screenWidth;

  const AuthHeader({super.key, required this.isSignUp, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            gradient: AppColors.blueToPurpleGradient,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: const LogoWidget(),
        ),
        const SizedBox(height: 16),
        Text(
          isSignUp ? 'createAccount'.tr() : 'welcomeBack'.tr(),
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isSignUp ? 'joinAurora'.tr() : 'signInToContinue'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
