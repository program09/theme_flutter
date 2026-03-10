import 'package:flutter/material.dart';
import 'package:ui/widgets/theme/colors.dart';

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
            ]else ... [
              const SizedBox(width: 10,)
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
