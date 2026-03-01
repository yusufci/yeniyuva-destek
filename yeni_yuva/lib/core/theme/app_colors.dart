import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF1565C0);       // Koyu Mavi - Güven
  static const Color primaryLight = Color(0xFF42A5F5);   // Açık Mavi
  static const Color primaryDark = Color(0xFF0D47A1);    // Çok Koyu Mavi

  // Secondary Colors
  static const Color secondary = Color(0xFF26A69A);      // Teal - Umut
  static const Color secondaryLight = Color(0xFF80CBC4);
  static const Color secondaryDark = Color(0xFF00897B);

  // Accent Colors
  static const Color accent = Color(0xFFFFA726);         // Turuncu - Sıcaklık

  // Background & Surface
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Category Colors
  static const Color categoryHealth = Color(0xFFE53935);
  static const Color categoryEducation = Color(0xFF1565C0);
  static const Color categoryLegal = Color(0xFF6A1B9A);
  static const Color categoryHousing = Color(0xFF2E7D32);
  static const Color categorySocialAid = Color(0xFFF57C00);
  static const Color categoryEmployment = Color(0xFF00838F);
  static const Color categoryCommunity = Color(0xFF5D4037);

  // Map helper
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'health':
        return categoryHealth;
      case 'education':
        return categoryEducation;
      case 'legal':
        return categoryLegal;
      case 'housing':
        return categoryHousing;
      case 'social_aid':
        return categorySocialAid;
      case 'employment':
        return categoryEmployment;
      case 'community':
        return categoryCommunity;
      default:
        return primary;
    }
  }
}