import 'package:flutter/material.dart';
import 'package:ui/widgets/theme/colors.dart';

enum TypeBadge {
  primary,
  secondary,
  success,
  danger,
  warning,
  info,
  light,
  dark,
}

enum StyleBadge { solid, mica }

class BadgeUI extends StatefulWidget {
  final String text;
  final TypeBadge type;
  final StyleBadge style;
  final bool? loading;
  final IconData? icon;

  const BadgeUI({
    super.key,
    required this.text,
    this.style = StyleBadge.solid,
    this.type = TypeBadge.primary,
    this.loading = false,
    this.icon,
  });

  @override
  State<BadgeUI> createState() => _BadgeUIState();
}

class _BadgeUIState extends State<BadgeUI> {
  Color _getBaseColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    switch (widget.type) {
      case TypeBadge.primary:
        return colorScheme.primary;
      case TypeBadge.secondary:
        return colorScheme.secondary;
      case TypeBadge.danger:
        return colorScheme.error;
      case TypeBadge.warning:
        return isDark ? AppColorsDark.warning : AppColorsLight.warning;
      case TypeBadge.info:
        return isDark ? AppColorsDark.info : AppColorsLight.info;
      case TypeBadge.success:
        return isDark ? AppColorsDark.success : AppColorsLight.success;
      case TypeBadge.light:
        return isDark
            ? AppColorsDark.surfaceVariant
            : AppColorsLight.surfaceVariant;
      case TypeBadge.dark:
        return isDark ? AppColorsDark.surface : AppColorsLight.surface;
    }
  }

  Color _getOnBaseColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    switch (widget.type) {
      case TypeBadge.primary:
        return colorScheme.onPrimary;
      case TypeBadge.secondary:
        return colorScheme.onSecondary;
      case TypeBadge.danger:
        return colorScheme.onError;
      case TypeBadge.warning:
        return isDark ? AppColorsLight.textPrimary : Colors.white;
      case TypeBadge.info:
      case TypeBadge.success:
        return isDark ? AppColorsDark.onSurface : Colors.white;
      case TypeBadge.light:
        return isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
      case TypeBadge.dark:
        return isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _getBaseColor(context);
    final onBaseColor = _getOnBaseColor(context);

    Color bgColor;
    Color fgColor;

    if (widget.style == StyleBadge.mica) {
      bgColor = baseColor.withValues(alpha: 0.15);
      fgColor = baseColor;
    } else {
      bgColor = baseColor;
      fgColor = onBaseColor;
    }

    final textStyle =
        Theme.of(context).textTheme.labelSmall?.copyWith(
          color: fgColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ) ??
        TextStyle(color: fgColor, fontWeight: FontWeight.w600, fontSize: 12);

    final showIcon = widget.icon != null && widget.loading != true;
    final showLoading = widget.loading == true;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showLoading) ...[
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(fgColor),
              ),
            ),
            if (widget.text.isNotEmpty) const SizedBox(width: 6),
          ],
          if (showIcon) ...[
            Icon(widget.icon, size: 14, color: fgColor),
            if (widget.text.isNotEmpty) const SizedBox(width: 4),
          ],
          if (widget.text.isNotEmpty) Text(widget.text, style: textStyle),
        ],
      ),
    );
  }
}
