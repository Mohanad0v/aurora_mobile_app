import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/theme/src/colors.dart';
import '../widgets/custom_button.dart';

class DialogUtils {
  static void showAlertDialog(
      BuildContext context, {
        required String title,
        required String message,
        String? buttonText,
        VoidCallback? onConfirm,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: AppColors.white,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.gray800,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16, color: AppColors.gray600),
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CustomButton(
                text: buttonText ?? 'OK',
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
                gradient: AppColors.auroraGradientPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showLoadingDialog(
      BuildContext context, {
        String message = 'انتظر قليلاً',
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: AppColors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.auroraBluePrimary),
              ),
              const SizedBox(height: 16),
              Text(
                message.tr(),
                style: const TextStyle(color: AppColors.gray700),
              ),
            ],
          ),
        );
      },
    );
  }

  static void dismissLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static void showSuccessDialog(
      BuildContext context, {
        required String title,
        required String message,
        required IconData icon,
        VoidCallback? onConfirmed,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: AppColors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.auroraGreen, size: 60),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(fontSize: 16, color: AppColors.gray600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'OK',
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirmed?.call();
                },
                gradient: AppColors.auroraGradientPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
