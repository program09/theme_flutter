import 'package:flutter/material.dart';

enum AppTheme { general, light, dark }

class AppGeneralColors {
  // PRIMARY
  static const primary = Color(0xFF2563EB);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFDCE7FF);
  static const onPrimaryContainer = Color(0xFF0A1F44);
}

class AppColorsLight {
  // SECONDARY
  static const secondary = Color(0xFF64748B);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFE2E8F0);
  static const onSecondaryContainer = Color(0xFF1E293B);

  // TERTIARY
  static const tertiary = Color(0xFF7C3AED);
  static const onTertiary = Color(0xFFFFFFFF);

  // BACKGROUND & SURFACE
  static const background = Color(0xFFF8FAFC);
  static const onBackground = Color(0xFF0F172A);

  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF0F172A);

  static const surfaceVariant = Color(0xFFF1F5F9);
  static const onSurfaceVariant = Color(0xFF334155);

  static const surfaceCard = Color(0xFFFFFFFF);
  static const onSurfaceCard = Color(0xFF0F172A);

  static const muted = Color(0xFFF1F5F9);
  static const onMuted = Color(0xFF334155);

  // ERROR
  static const error = Color(0xFFDC2626);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFEE2E2);
  static const onErrorContainer = Color(0xFF7F1D1D);

  // STATUS
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF0EA5E9);

  // OUTLINE & DIVIDER
  static const outline = Color(0xFFE2E8F0);
  static const divider = Color(0xFFE5E7EB);

  // TEXT HIERARCHY
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const textTertiary = Color(0xFF64748B);
  static const textDisabled = Color(0xFF94A3B8);
  static const placeholder = Color(0xFF9CA3AF);

  // ICONS
  static const iconPrimary = Color(0xFF1E293B);
  static const iconSecondary = Color(0xFF64748B);

  // EFFECTS
  static const shadow = Color(0x1A000000);
  static const scrim = Color(0x66000000);
}

class AppColorsDark {
  // SECONDARY
  static const secondary = Color(0xFF94A3B8);
  static const onSecondary = Color(0xFF0F172A);
  static const secondaryContainer = Color(0xFF334155);
  static const onSecondaryContainer = Color(0xFFE2E8F0);

  // TERTIARY
  static const tertiary = Color(0xFFA78BFA);
  static const onTertiary = Color(0xFF1E1B4B);

  // BACKGROUND & SURFACE
  static const background = Color.fromARGB(255, 17, 26, 47);
  static const onBackground = Color(0xFFFFFFFF);

  static const surface = Color(0xFF1E293B);
  static const onSurface = Color(0xFFFFFFFF);

  static const surfaceVariant = Color(0xFF334155);
  static const onSurfaceVariant = Color(0xFFE2E8F0);

  static const surfaceCard = Color(0xFF1E293B);
  static const onSurfaceCard = Color(0xFFFFFFFF);

  static const muted = Color(0xFF334155);
  static const onMuted = Color(0xFFE2E8F0);

  // ERROR
  static const error = Color(0xFFF87171);
  static const onError = Color(0xFF450A0A);
  static const errorContainer = Color(0xFF7F1D1D);
  static const onErrorContainer = Color(0xFFFEE2E2);

  // STATUS
  static const success = Color(0xFF4ADE80);
  static const warning = Color(0xFFFBBF24);
  static const info = Color(0xFF38BDF8);

  // OUTLINE & DIVIDER
  static const outline = Color(0xFF334155);
  static const divider = Color(0xFF475569);

  // TEXT HIERARCHY
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFCBD5E1);
  static const textTertiary = Color(0xFF94A3B8);
  static const textDisabled = Color(0xFF64748B);
  static const placeholder = Color(0xFF94A3B8);

  // ICONS
  static const iconPrimary = Color(0xFFFFFFFF);
  static const iconSecondary = Color(0xFFCBD5E1);

  // EFFECTS
  static const shadow = Color(0x33000000);
  static const scrim = Color(0x99000000);
}
