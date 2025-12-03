import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/theme/src/colors.dart';

enum ButtonVariant { primary, outline, gradient }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final LinearGradient? gradient;
  final IconData? icon;
  final Icon? prefixIcon;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.gradient,
    this.icon,
    this.padding,
    this.height = 48,
    this.textColor,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: textColor ??
                (variant == ButtonVariant.outline ? AppColors.gray700 : AppColors.white),
            size: 20,
          ),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor ??
                  (variant == ButtonVariant.outline ? AppColors.gray700 : AppColors.white),
            ),
          ),
        ),
      ],
    );

    final EdgeInsetsGeometry effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    switch (variant) {
      case ButtonVariant.primary:
        return SizedBox(
          height: height,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.auroraBluePrimary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: effectivePadding,
              elevation: 0,
            ),
            child: buttonContent,
          ),
        );

      case ButtonVariant.outline:
        return SizedBox(
          height: height,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.gray700,
              side: const BorderSide(color: AppColors.gray200, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: effectivePadding,
            ),
            child: buttonContent,
          ),
        );

      case ButtonVariant.gradient:
        return Container(
          height: height,
          decoration: BoxDecoration(
            gradient: gradient ?? AppColors.auroraGradientPrimary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: (gradient?.colors[0] ?? AppColors.auroraBluePrimary)
                    .withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: Padding(
                  padding: effectivePadding,
                  child: buttonContent,
                ),
              ),
            ),
          ),
        );
    }
  }
}
