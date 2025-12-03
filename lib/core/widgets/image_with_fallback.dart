import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/theme/src/colors.dart';

class ImageWithFallback extends StatelessWidget {
  final String imageUrl;
  final BoxFit boxFit;
  final double? height;
  final double? width;
  final double borderRadius;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  const ImageWithFallback({
    super.key,
    required this.imageUrl,
    this.boxFit = BoxFit.cover,
    this.height,
    this.width,
    this.borderRadius = 8.0,
    this.topLeft = true,
    this.topRight = true,
    this.bottomLeft = true,
    this.bottomRight = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: topLeft ? Radius.circular(borderRadius) : Radius.zero,
        topRight: topRight ? Radius.circular(borderRadius) : Radius.zero,
        bottomLeft: bottomLeft ? Radius.circular(borderRadius) : Radius.zero,
        bottomRight: bottomRight ? Radius.circular(borderRadius) : Radius.zero,
      ),
      child: Image.network(
        imageUrl,
        fit: boxFit,
        height: height,
        width: width,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: AppColors.gray200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported_outlined, color: AppColors.gray500, size: (height ?? 50) * 0.4),
                  if (height != null && height! > 50) ...[
                    const SizedBox(height: 8),
                    Text(
                      "failedToFetchProperties".tr(), // Using a generic error string, could be more specific
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.gray600,
                        fontSize: (height ?? 50) * 0.15,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}