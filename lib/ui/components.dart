import 'package:flutter/material.dart';
import 'package:ui/ui/theme.dart';

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

// start: BottomModalUI

class BottomModalUI extends StatelessWidget {
  final double? minHeight;
  final double? maxHeight;
  final List<Widget> children;

  const BottomModalUI({
    super.key,
    this.minHeight,
    this.maxHeight,
    required this.children,
  });

  /// Static method to quickly show the bottom modal anywhere
  static Future<T?> show<T>({
    required BuildContext context,
    double? minHeight,
    double? maxHeight,
    required List<Widget> children,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      barrierColor: const Color.fromARGB(70, 0, 0, 0),
      backgroundColor: Colors.transparent, // Background handled within
      builder: (BuildContext context) {
        return BottomModalUI(
          minHeight: minHeight,
          maxHeight: maxHeight,
          children: children,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        // Push up when keyboard appears
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: MediaQuery.of(context).size.height * 0.04,
        ),
        child: Container(
          constraints: BoxConstraints(
            minHeight: minHeight ?? 200,
            maxHeight: maxHeight ?? MediaQuery.sizeOf(context).height * 0.8,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.4,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),

              // Custom Payload content
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Column(children: children),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// end: BottomModalUI

// start: ModalUI

class ModalUI extends StatelessWidget {
  final String? title;
  final TextAlign? textAlign;
  final List<Widget> children;
  final List<Widget>? actions;
  final bool showDivider;
  final double? maxWidth;

  const ModalUI({
    super.key,
    this.title,
    this.textAlign,
    required this.children,
    this.actions,
    this.showDivider = true,
    this.maxWidth,
  });

  /// Static method to quickly show a centered modal anywhere
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    TextAlign? textAlign,
    required List<Widget> children,
    List<Widget>? actions,
    final bool showDivider = true,
    bool isDismissible = true,
    double? maxWidth,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierColor: const Color.fromARGB(70, 0, 0, 0),
      builder: (BuildContext context) {
        return ModalUI(
          title: title,
          textAlign: textAlign,
          maxWidth: maxWidth,
          actions: actions,
          showDivider: showDivider,
          children: children,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? 400,
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: textAlign ?? TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ),
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 20),
              if (showDivider) ...[Divider(), const SizedBox(height: 10)],
              Row(mainAxisAlignment: MainAxisAlignment.end, children: actions!),
            ],
          ],
        ),
      ),
    );
  }
}

// end: ModalUI

// start: cardUI

class CardAspectRatio {
  static const String square = '1:1';
  static const String landscape = '16:9';
  static const String portrait = '9:16';
  static const String classic = '4:3'; // Clásico apaisado/horizontal
  static const String classicPortrait = '3:4'; // Clásico retrato/vertical
  static String custom(double w, double h) => '$w:$h';
}

Widget cardUI({
  required List<Widget> children,
  bool withPadding = true,
  EdgeInsetsGeometry? padding,
  String? aspectRatio, // formato: '1:1', '16:9', '3:4', etc.
}) {
  Widget childrenLocal = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: children,
  );

  Widget card = Builder(
    builder: (context) {
      final theme = Theme.of(context);

      return Card(
        shadowColor: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.15),
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: .5),
            width: 1,
          ),
        ),
        child: withPadding
            ? Padding(
                padding: padding ?? const EdgeInsets.all(15),
                child: childrenLocal,
              )
            : childrenLocal,
      );
    },
  );

  if (aspectRatio != null && aspectRatio.contains(':')) {
    final parts = aspectRatio.split(':');
    if (parts.length == 2) {
      final w = double.tryParse(parts[0]);
      final h = double.tryParse(parts[1]);
      if (w != null && h != null && h > 0) {
        return AspectRatio(aspectRatio: w / h, child: card);
      }
    }
  }

  return card;
}

// end: cardUI

// start: gridUI

Widget gridUI({
  required List<Widget> children,
  int columns = 2,
  double spacing = 10.0,
  double runSpacing = 10.0,
  EdgeInsetsGeometry? padding,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Calculamos el ancho exacto que debe tener cada columna
      // restando el espacio total de separación entre ellas
      final double totalSpacing = spacing * (columns - 1);
      final double itemWidth = (constraints.maxWidth - totalSpacing) / columns;

      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            return SizedBox(width: itemWidth, child: child);
          }).toList(),
        ),
      );
    },
  );
}

// end: gridUI
