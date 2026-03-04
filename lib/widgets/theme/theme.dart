import 'package:flutter/material.dart';
import 'package:ui/widgets/theme/colors.dart';

enum AppThemeMode { light, dark, system }

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
