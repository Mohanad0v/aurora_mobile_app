import 'dart:ui';

import 'package:aurora_app/features/auth/presentation/widgets/social_buttons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/theme/src/colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input_field.dart';

class AuthForm extends StatelessWidget {
  final bool isSignUp;
  final bool showPassword;
  final VoidCallback togglePassword;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final bool isArabic;
  final VoidCallback toggleAuthMode;

  const AuthForm({
    super.key,
    required this.isSignUp,
    required this.showPassword,
    required this.togglePassword,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.isArabic,
    required this.toggleAuthMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.gray100, blurRadius: 8, spreadRadius: 2),
        ],
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        children: [
          if (isSignUp) ...[
            CustomInputField(
              controller: nameController,
              hintText: 'fullName'.tr(),
              prefixIcon: Icons.person_outline,
              required: true,
            ),
            const SizedBox(height: 16),
          ],
          CustomInputField(
            controller: emailController,
            hintText: 'email'.tr(),
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            required: true,
          ),
          const SizedBox(height: 16),
          CustomInputField(
            controller: passwordController,
            hintText: 'password'.tr(),
            prefixIcon: Icons.lock_outline,
            obscureText: !showPassword,
            suffixIcon: IconButton(
              icon: Icon(
                showPassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.gray400,
              ),
              onPressed: togglePassword,
            ),
            required: true,
          ),
          if (!isSignUp)
            Align(
              alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'forgotPassword'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.auroraBluePrimary,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          CustomButton(
            text: isSignUp ? 'createAccount'.tr() : 'signIn'.tr(),
            onPressed: onSubmit,
            gradient: AppColors.auroraGradientPrimary,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.gray200)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'orContinueWith'.tr(),
                  style: const TextStyle(color: AppColors.gray500),
                ),
              ),
              const Expanded(child: Divider(color: AppColors.gray200)),
            ],
          ),
          const SizedBox(height: 16),
          const SocialButtons (),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: toggleAuthMode,
            child: Text.rich(
              TextSpan(
                text: isSignUp ? 'alreadyHaveAccount'.tr() : 'dontHaveAccount'.tr(),
                style: const TextStyle(color: AppColors.gray600),
                children: [
                  TextSpan(
                    text: isSignUp ? 'signIn'.tr() : 'createAccount'.tr(),
                    style: const TextStyle(
                      color: AppColors.auroraBluePrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
