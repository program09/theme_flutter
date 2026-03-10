import 'package:flutter/material.dart';
import 'package:ui/widgets/theme/colors.dart';

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
