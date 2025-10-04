import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/custom_button.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomSocialButton(
            text: 'google'.tr(),
            onPressed: () {
              // Handle Google login
            },
            prefixIcon: SvgPicture.asset(
              'assets/images/google_icon.svg', // your SVG path
              width: 20,
              height: 20,
            ),
            variant: ButtonVariant.outline,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomSocialButton(
            text: 'apple'.tr(),
            onPressed: () {
              // Handle Apple login
            },
            prefixIcon: const FaIcon(
              FontAwesomeIcons.apple,
              color: Colors.black, // Apple black
            ),
            variant: ButtonVariant.outline,
          ),
        ),
      ],
    );
  }
}

class CustomSocialButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final Widget? prefixIcon;
  final bool isLoading;

  const CustomSocialButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.outline,
    this.prefixIcon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isOutline = variant == ButtonVariant.outline;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutline ? Colors.transparent : Theme.of(context).primaryColor,
        elevation: 0,
        foregroundColor: Colors.black,
        side: isOutline ? const BorderSide(color: Colors.grey) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
            )
          else ...[
            if (prefixIcon != null) ...[
              prefixIcon!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
