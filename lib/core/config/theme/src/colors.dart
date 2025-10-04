import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppColors {
  // Primary Colors
  static const Color auroraBluePrimary = Color(0xFF3550E1);
  static const Color auroraPurple = Color(0xFF9B59B6);
  static const Color auroraTeal = Color(0xFF1ABC9C);
  static const Color auroraGreen = Color(0xFF4BE0B2);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);

  // Status Colors
  static const Color success = Color(0xFF10B981); // Available
  static const Color warning = Color(0xFFF59E0B); // Pending
  static const Color error = Color(0xFFEF4444); // Sold
  static const Color info = Color(0xFF3B82F6); // Rented

  // Background and Foreground based on :root variables in globals.css
  static const Color background = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF252525); // Close to oklch(0.145 0 0)

  // Gradients
  static const LinearGradient auroraGradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3550E1), // #3550E1
      Color(0xFF6B78E0), // #6B78E0
      Color(0xFF9B59B6), // #9B59B6
    ],
  );

  static const LinearGradient auroraGradientSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8387E2), // #8387E2
      Color(0xFF4BE0B2), // #4BE0B2
      Color(0xFF1ABC9C), // #1ABC9C
    ],
  );

  static const LinearGradient auroraGradientSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE8EAFF), // #E8EAFF
      Color(0xFFF0E8FF), // #F0E8FF
      Color(0xFFFFE8F4), // #FFE8F4
    ],
  );

  static const LinearGradient auroraGradientBg = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3550E1), // #3550E1
      Color(0xFF9B59B6), // #9B59B6
      Color(0xFF4BE0B2), // #4BE0B2
    ],
  );

  // Specific gradients used in components
  static const LinearGradient blueToPurpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3B82F6), // blue-500
      Color(0xFF9B59B6), // purple-600 (from AuthScreen)
    ],
  );

  static const LinearGradient redToPinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEF4444), // red-500
      Color(0xFFEC4899), // pink-500
    ],
  );

  static const LinearGradient yellowToOrangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF59E0B), // yellow-500
      Color(0xFFF97316), // orange-500
    ],
  );

  static const LinearGradient grayToGrayGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6B7280), // gray-500
      Color(0xFF4B5563), // gray-600
    ],
  );

  static const LinearGradient greenToTealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF22C55E), // green-500
      Color(0xFF14B8A6), // teal-500
    ],
  );

  static const LinearGradient blueToCyanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3B82F6), // blue-500
      Color(0xFF06B6D4), // cyan-500
    ],
  );
}
