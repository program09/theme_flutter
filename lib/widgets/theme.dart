import 'package:flutter/material.dart';

// Mode theme definition
enum AppThemeMode { light, dark, system }

// Colors definition
enum AppThemeColors { general, light, dark }

// start: AppGeneralColors
class AppGeneralColors {
  // PRIMARY
  static const primary = Color(0xFF2563EB);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFDCE7FF);
  static const onPrimaryContainer = Color(0xFF0A1F44);
}
// end: AppGeneralColors

// start: AppColorsLight
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
// end: AppColorsLight

// start: AppColorsDark
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
// end: AppColorsDark

// start: AppTheme
class AppTheme {
  // ==========================================================
  // LIGHT THEME
  // ==========================================================

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // ----------------------------------------------------------
    // COLOR SCHEME
    // ----------------------------------------------------------
    colorScheme: const ColorScheme(
      brightness: Brightness.light,

      primary: AppGeneralColors.primary,
      onPrimary: AppGeneralColors.onPrimary,
      primaryContainer: AppGeneralColors.primaryContainer,
      onPrimaryContainer: AppGeneralColors.onPrimaryContainer,

      secondary: AppColorsLight.secondary,
      onSecondary: AppColorsLight.onSecondary,
      secondaryContainer: AppColorsLight.secondaryContainer,
      onSecondaryContainer: AppColorsLight.onSecondaryContainer,

      tertiary: AppColorsLight.tertiary,
      onTertiary: AppColorsLight.onTertiary,

      error: AppColorsLight.error,
      onError: AppColorsLight.onError,

      surface: AppColorsLight.surface,
      onSurface: AppColorsLight.onSurface,

      outline: AppColorsLight.outline,
    ),

    scaffoldBackgroundColor: AppColorsLight.background,

    // ----------------------------------------------------------
    // TYPOGRAPHY
    // ----------------------------------------------------------
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColorsLight.textPrimary),
      displayMedium: TextStyle(color: AppColorsLight.textPrimary),
      displaySmall: TextStyle(color: AppColorsLight.textPrimary),
      headlineLarge: TextStyle(color: AppColorsLight.textPrimary),
      headlineMedium: TextStyle(color: AppColorsLight.textPrimary),
      headlineSmall: TextStyle(color: AppColorsLight.textPrimary),
      bodyLarge: TextStyle(color: AppColorsLight.textPrimary),
      bodyMedium: TextStyle(color: AppColorsLight.textSecondary),
      bodySmall: TextStyle(color: AppColorsLight.textTertiary),
      labelLarge: TextStyle(color: AppColorsLight.textPrimary),
    ),

    // ----------------------------------------------------------
    // APP STRUCTURE
    // ----------------------------------------------------------
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsLight.surface,
      foregroundColor: AppColorsLight.textPrimary,
      elevation: 0,
    ),

    drawerTheme: const DrawerThemeData(backgroundColor: AppColorsLight.surface),

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColorsLight.surface,
      indicatorColor: AppGeneralColors.primaryContainer,
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: AppGeneralColors.primary,
      unselectedLabelColor: AppColorsLight.textSecondary,
      indicatorColor: AppGeneralColors.primary,
    ),

    // ----------------------------------------------------------
    // SURFACES
    // ----------------------------------------------------------
    cardTheme: const CardThemeData(
      color: AppColorsLight.surface,
      shadowColor: AppColorsLight.shadow,
      elevation: 1,
    ),

    dialogTheme: const DialogThemeData(backgroundColor: AppColorsLight.surface),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColorsLight.surface,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColorsLight.divider,
      thickness: 1,
    ),

    // ----------------------------------------------------------
    // BUTTONS
    // ----------------------------------------------------------
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppGeneralColors.primary,
        foregroundColor: AppGeneralColors.onPrimary,
        disabledBackgroundColor: AppColorsLight.muted,
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppGeneralColors.primary,
        foregroundColor: AppGeneralColors.onPrimary,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppGeneralColors.primary,
        side: const BorderSide(color: AppGeneralColors.primary),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppGeneralColors.primary),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: AppColorsLight.iconPrimary),
    ),

    iconTheme: const IconThemeData(color: AppColorsLight.iconPrimary),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppGeneralColors.primary,
      foregroundColor: AppGeneralColors.onPrimary,
    ),

    // ----------------------------------------------------------
    // INPUTS
    // ----------------------------------------------------------
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColorsLight.surfaceVariant,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: TextStyle(fontWeight: FontWeight.w500),
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: AppColorsLight.placeholder,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColorsLight.outline, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColorsLight.outline, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppGeneralColors.primary, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColorsLight.error, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColorsLight.error, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    ),

    // ----------------------------------------------------------
    // SELECTION CONTROLS
    // ----------------------------------------------------------
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(AppGeneralColors.primary),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(AppGeneralColors.primary),
    ),

    switchTheme: SwitchThemeData(
      trackOutlineColor: WidgetStateProperty.all(AppColorsLight.outline),
      trackOutlineWidth: WidgetStateProperty.all(2),
      trackColor: WidgetStateProperty.all(AppColorsLight.surfaceVariant),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppGeneralColors.primary;
        }
        return AppColorsLight.outline;
      }),

      thumbIcon: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Icon(
            Icons.check,
            size: 16,
            color: AppColorsLight.outline,
          );
        }
        return const Icon(Icons.close, size: 16);
      }),
    ),

    sliderTheme: const SliderThemeData(
      activeTrackColor: AppGeneralColors.primary,
      thumbColor: AppGeneralColors.primary,
    ),

    // ----------------------------------------------------------
    // FEEDBACK
    // ----------------------------------------------------------
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppGeneralColors.primary,
    ),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColorsLight.surface,
      contentTextStyle: TextStyle(color: AppColorsLight.textPrimary),
    ),

    tooltipTheme: const TooltipThemeData(
      decoration: BoxDecoration(color: AppColorsLight.surfaceVariant),
      textStyle: TextStyle(color: Colors.white),
    ),

    chipTheme: const ChipThemeData(
      backgroundColor: AppColorsLight.surfaceVariant,
      selectedColor: AppGeneralColors.primary,
      labelStyle: TextStyle(color: AppColorsLight.textPrimary),
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: AppColorsLight.iconSecondary,
      textColor: AppColorsLight.textPrimary,
    ),

    dropdownMenuTheme: const DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsLight.surfaceVariant,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColorsLight.textPrimary,
        ),
        hintStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColorsLight.placeholder,
        ),
      ),
      menuStyle: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
    ),
  );

  // ==========================================================
  // DARK THEME
  // ==========================================================

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // ----------------------------------------------------------
    // COLOR SCHEME
    // ----------------------------------------------------------
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,

      primary: AppGeneralColors.primary,
      onPrimary: AppGeneralColors.onPrimary,
      primaryContainer: AppGeneralColors.primaryContainer,
      onPrimaryContainer: AppGeneralColors.onPrimaryContainer,

      secondary: AppColorsDark.secondary,
      onSecondary: AppColorsDark.onSecondary,
      secondaryContainer: AppColorsDark.secondaryContainer,
      onSecondaryContainer: AppColorsDark.onSecondaryContainer,

      tertiary: AppColorsDark.tertiary,
      onTertiary: AppColorsDark.onTertiary,

      error: AppColorsDark.error,
      onError: AppColorsDark.onError,

      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.onSurface,

      outline: AppColorsDark.outline,
    ),

    scaffoldBackgroundColor: AppColorsDark.background,

    // ----------------------------------------------------------
    // TYPOGRAPHY
    // ----------------------------------------------------------
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColorsDark.textPrimary),
      displayMedium: TextStyle(color: AppColorsDark.textPrimary),
      displaySmall: TextStyle(color: AppColorsDark.textPrimary),
      headlineLarge: TextStyle(color: AppColorsDark.textPrimary),
      headlineMedium: TextStyle(color: AppColorsDark.textPrimary),
      headlineSmall: TextStyle(color: AppColorsDark.textPrimary),
      bodyLarge: TextStyle(color: AppColorsDark.textPrimary),
      bodyMedium: TextStyle(color: AppColorsDark.textSecondary),
      bodySmall: TextStyle(color: AppColorsDark.textTertiary),
      labelLarge: TextStyle(color: AppColorsDark.textPrimary),
    ),

    // ----------------------------------------------------------
    // APP STRUCTURE
    // ----------------------------------------------------------
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsDark.surface,
      foregroundColor: AppColorsDark.textPrimary,
      elevation: 0,
    ),

    drawerTheme: const DrawerThemeData(backgroundColor: AppColorsDark.surface),

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColorsDark.surface,
      indicatorColor: AppGeneralColors.primaryContainer,
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: AppGeneralColors.primary,
      unselectedLabelColor: AppColorsDark.textSecondary,
      indicatorColor: AppGeneralColors.primary,
    ),

    // ----------------------------------------------------------
    // SURFACES
    // ----------------------------------------------------------
    cardTheme: const CardThemeData(
      color: AppColorsDark.surface,
      shadowColor: AppColorsDark.shadow,
      elevation: 1,
    ),

    dialogTheme: const DialogThemeData(backgroundColor: AppColorsDark.surface),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColorsDark.surface,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColorsDark.divider,
      thickness: 1,
    ),

    // ----------------------------------------------------------
    // BUTTONS
    // ----------------------------------------------------------
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppGeneralColors.primary,
        foregroundColor: AppGeneralColors.onPrimary,
        disabledBackgroundColor: AppColorsDark.muted,
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppGeneralColors.primary,
        foregroundColor: AppGeneralColors.onPrimary,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppGeneralColors.primary,
        side: const BorderSide(color: AppGeneralColors.primary),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppGeneralColors.primary),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: AppColorsDark.iconPrimary),
    ),

    iconTheme: const IconThemeData(color: AppColorsDark.iconPrimary),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppGeneralColors.primary,
      foregroundColor: AppGeneralColors.onPrimary,
    ),

    // ----------------------------------------------------------
    // INPUTS
    // ----------------------------------------------------------
    inputDecorationTheme: const InputDecorationTheme(
      filled: false,
      fillColor: AppColorsDark.surfaceVariant,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: TextStyle(fontWeight: FontWeight.w500),
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: AppColorsDark.outline,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColorsDark.outline, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColorsDark.outline, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppGeneralColors.primary, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColorsDark.error, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColorsDark.error, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    ),

    // ----------------------------------------------------------
    // SELECTION CONTROLS
    // ----------------------------------------------------------
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(AppGeneralColors.primary),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(AppGeneralColors.primary),
    ),

    switchTheme: SwitchThemeData(
      trackOutlineColor: WidgetStateProperty.all(AppColorsDark.outline),
      trackOutlineWidth: WidgetStateProperty.all(2),
      trackColor: WidgetStateProperty.all(AppColorsDark.surface),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppGeneralColors.primary;
        }
        return AppColorsDark.outline;
      }),

      thumbIcon: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Icon(
            Icons.check,
            size: 16,
            color: AppColorsDark.iconSecondary,
          );
        }
        return const Icon(Icons.close, size: 16);
      }),
    ),

    sliderTheme: const SliderThemeData(
      activeTrackColor: AppGeneralColors.primary,
      thumbColor: AppGeneralColors.primary,
    ),

    // ----------------------------------------------------------
    // FEEDBACK
    // ----------------------------------------------------------
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppGeneralColors.primary,
    ),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColorsDark.surface,
      contentTextStyle: TextStyle(color: AppColorsDark.textPrimary),
    ),

    tooltipTheme: const TooltipThemeData(
      decoration: BoxDecoration(color: AppColorsDark.surfaceVariant),
      textStyle: TextStyle(color: Colors.white),
    ),

    chipTheme: const ChipThemeData(
      backgroundColor: AppColorsDark.surfaceVariant,
      selectedColor: AppGeneralColors.primary,
      labelStyle: TextStyle(color: AppColorsDark.textPrimary),
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: AppColorsDark.iconSecondary,
      textColor: AppColorsDark.textPrimary,
    ),

    dropdownMenuTheme: const DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        fillColor: AppColorsDark.surfaceVariant,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColorsDark.textPrimary,
        ),
        hintStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColorsDark.outline,
        ),
      ),
      menuStyle: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
    ),
  );
}

// end: AppTheme
