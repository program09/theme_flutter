import 'package:flutter/material.dart';
import 'package:ui/widgets/theme.dart';

enum StyleAlert { solid, mica }

enum TypeAlert {
  primary,
  secondary,
  success,
  danger,
  warning,
  info,
  light,
  dark,
}

// start: AlertsUI
class AlertsUI extends StatefulWidget {
  final String? title;
  final String? message;
  final StyleAlert style;
  final TypeAlert type;
  final IconData? icon;
  final bool? visible;
  final bool? closed;

  const AlertsUI({
    super.key,
    this.title,
    this.message,
    this.style = StyleAlert.solid,
    this.type = TypeAlert.primary,
    this.icon,
    this.visible = true,
    this.closed = true,
  });

  @override
  State<AlertsUI> createState() => _AlertsUIState();
}

class _AlertsUIState extends State<AlertsUI> {
  bool visible = true;

  Color _getBaseColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    switch (widget.type) {
      case TypeAlert.primary:
        return colorScheme.primary;
      case TypeAlert.secondary:
        return colorScheme.secondary;
      case TypeAlert.danger:
        return colorScheme.error;
      case TypeAlert.warning:
        return isDark ? AppColorsDark.warning : AppColorsLight.warning;
      case TypeAlert.info:
        return isDark ? AppColorsDark.info : AppColorsLight.info;
      case TypeAlert.success:
        return isDark ? AppColorsDark.success : AppColorsLight.success;
      case TypeAlert.light:
        return isDark
            ? AppColorsDark.surfaceVariant
            : AppColorsLight.surfaceVariant;
      case TypeAlert.dark:
        return isDark ? AppColorsDark.surface : AppColorsLight.surface;
    }
  }

  Color _getOnBaseColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    switch (widget.type) {
      case TypeAlert.primary:
        return colorScheme.onPrimary;
      case TypeAlert.secondary:
        return colorScheme.onSecondary;
      case TypeAlert.danger:
        return colorScheme.onError;
      case TypeAlert.warning:
        return isDark ? AppColorsLight.textPrimary : Colors.white;
      case TypeAlert.info:
      case TypeAlert.success:
        return isDark ? AppColorsDark.onSurface : Colors.white;
      case TypeAlert.light:
        return isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
      case TypeAlert.dark:
        return isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _getBaseColor(context);
    final onBaseColor = _getOnBaseColor(context);

    Color bgColor;
    Color fgColor;
    Color borderColor = Colors.transparent;

    if (widget.style == StyleAlert.mica) {
      bgColor = baseColor.withValues(alpha: 0.15);
      fgColor = baseColor;
      borderColor = baseColor.withValues(alpha: 0.3);
    } else {
      bgColor = baseColor;
      fgColor = onBaseColor;
    }

    void onClose() {
      setState(() {
        visible = false;
      });
    }

    return Visibility(
      visible: visible,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.icon != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 0, right: 12),
                child: Icon(widget.icon, color: fgColor, size: 24),
              ),
            ] else ...[
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.title != null && widget.title!.isNotEmpty) ...[
                    Text(
                      widget.title!,
                      style: TextStyle(
                        color: fgColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  if (widget.message != null && widget.message!.isNotEmpty)
                    Text(
                      widget.message!,
                      style: TextStyle(color: fgColor, fontSize: 14),
                    ),
                ],
              ),
            ),
            if (widget.closed != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: onClose,
                iconSize: 16,
                padding: EdgeInsets.all(10),
                constraints: const BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  Icons.close,
                  size: 16,
                  color: fgColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// end: AlertsUI

// start: badge

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

// end: badge

// start: bottons

enum TypeBtn { primary, secondary, danger, warning, info, success }

enum StyleBtn { solid, outline, mica, text }

class BtnUI extends StatefulWidget {
  final String text;
  final TypeBtn? type;
  final StyleBtn? style;
  final bool disabled;
  final bool loading;
  final IconData? icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool? fullWidth;

  const BtnUI({
    super.key,
    this.text = '',
    this.type = TypeBtn.primary,
    this.style = StyleBtn.solid,
    this.disabled = false,
    this.loading = false,
    this.fullWidth = false,
    this.icon,
    this.onPressed,
    this.onLongPress,
  });

  @override
  State<BtnUI> createState() => _BtnUIState();
}

class _BtnUIState extends State<BtnUI> {
  EdgeInsetsGeometry? _getPadding() =>
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14);

  Color _getBaseColor(bool isDark) {
    switch (widget.type) {
      case TypeBtn.primary:
        return AppGeneralColors.primary;
      case TypeBtn.secondary:
        return isDark ? AppColorsDark.secondary : AppColorsLight.secondary;
      case TypeBtn.danger:
        return isDark ? AppColorsDark.error : AppColorsLight.error;
      case TypeBtn.warning:
        return isDark ? AppColorsDark.warning : AppColorsLight.warning;
      case TypeBtn.info:
        return isDark ? AppColorsDark.info : AppColorsLight.info;
      case TypeBtn.success:
        return isDark ? AppColorsDark.success : AppColorsLight.success;
      default:
        return AppGeneralColors.primary;
    }
  }

  Color _getOnBaseColor(bool isDark) {
    switch (widget.type) {
      case TypeBtn.primary:
        return AppGeneralColors.onPrimary;
      case TypeBtn.secondary:
        return isDark ? AppColorsDark.onSecondary : AppColorsLight.onSecondary;
      case TypeBtn.danger:
        return isDark ? AppColorsDark.onError : AppColorsLight.onError;
      default:
        return Colors.white;
    }
  }

  Widget _buildContent(Color foregroundColor) {
    if (widget.loading) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: 18),
          if (widget.text.isNotEmpty) const SizedBox(width: 8),
          if (widget.text.isNotEmpty)
            Text(
              widget.text,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
        ],
      );
    }

    return Text(
      widget.text,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = _getBaseColor(isDark);
    final onBaseColor = _getOnBaseColor(isDark);

    final disabledBg = isDark ? AppColorsDark.muted : AppColorsLight.muted;
    final disabledFg = isDark
        ? AppColorsDark.textDisabled
        : AppColorsLight.textDisabled;
    final outlineColor = isDark
        ? AppColorsDark.outline
        : AppColorsLight.outline;

    final isDisabled = widget.disabled || widget.loading;

    Color fgColor;
    if (isDisabled) {
      fgColor = disabledFg;
    } else {
      if (widget.style == StyleBtn.solid) {
        fgColor = onBaseColor;
      } else {
        fgColor = baseColor;
      }
    }

    Widget content = _buildContent(fgColor);

    final minSize = widget.fullWidth == true
        ? const Size(double.infinity, 45)
        : const Size(45, 45);

    switch (widget.style) {
      case StyleBtn.outline:
        return OutlinedButton(
          onPressed: isDisabled ? null : widget.onPressed,
          onLongPress: isDisabled ? null : widget.onLongPress,
          style: OutlinedButton.styleFrom(
            minimumSize: minSize,
            foregroundColor: baseColor,
            disabledForegroundColor: disabledFg,
            side: BorderSide(color: isDisabled ? outlineColor : baseColor),
            padding: _getPadding(),
            elevation: 0,
          ),
          child: content,
        );
      case StyleBtn.mica:
        return ElevatedButton(
          onPressed: isDisabled ? null : widget.onPressed,
          onLongPress: isDisabled ? null : widget.onLongPress,
          style: ElevatedButton.styleFrom(
            backgroundColor: baseColor.withValues(alpha: 0.15),
            foregroundColor: baseColor,
            disabledBackgroundColor: disabledBg,
            disabledForegroundColor: disabledFg,
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: _getPadding(),
            minimumSize: minSize,
          ),
          child: content,
        );
      case StyleBtn.text:
        return TextButton(
          onPressed: isDisabled ? null : widget.onPressed,
          onLongPress: isDisabled ? null : widget.onLongPress,
          style: TextButton.styleFrom(
            foregroundColor: baseColor,
            disabledForegroundColor: disabledFg,
            padding: _getPadding(),
            minimumSize: minSize,
          ),
          child: content,
        );
      case StyleBtn.solid:
      default:
        return ElevatedButton(
          onPressed: isDisabled ? null : widget.onPressed,
          onLongPress: isDisabled ? null : widget.onLongPress,
          style: ElevatedButton.styleFrom(
            backgroundColor: baseColor,
            foregroundColor: onBaseColor,
            disabledBackgroundColor: disabledBg,
            disabledForegroundColor: disabledFg,
            padding: _getPadding(),
            minimumSize: minSize,
          ),
          child: content,
        );
    }
  }
}

// end: bottons
