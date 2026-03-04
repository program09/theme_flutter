import 'package:flutter/material.dart';
import 'package:ui/widgets/forms/options.dart';

class SelectUI extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final List<Option>? options;
  final String? value;
  final ValueChanged<Option?>? onChanged;
  final String? Function(Option?)? validator;
  final bool disabled;
  final IconData? prefixIcon;

  const SelectUI({
    super.key,
    required this.label,
    this.hintText,
    this.errorText,
    this.options,
    this.value,
    this.onChanged,
    this.validator,
    this.disabled = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = options == null || options!.isEmpty;
    final String effectiveHint = isEmpty
        ? 'No hay opciones disponibles'
        : (hintText ?? 'Seleccionar una opcion');

    Option? getOption() {
      if (value == null || options == null) return null;
      try {
        return options!.firstWhere(
          (option) => option.value.toString() == value.toString(),
        );
      } catch (_) {
        return null;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownMenu<Option>(
          initialSelection: getOption(),
          width: constraints.maxWidth,
          menuHeight: 250,
          menuStyle: MenuStyle(
            elevation: const WidgetStatePropertyAll(8.0),
            shadowColor: WidgetStatePropertyAll(
              Colors.black.withValues(alpha: 0.4),
            ),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
          label: Text(label),
          hintText: effectiveHint,
          errorText: errorText,
          enabled: !(disabled || isEmpty),
          leadingIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          dropdownMenuEntries: options!
              .map(
                (option) => DropdownMenuEntry<Option>(
                  value: option,
                  label: option.label,
                ),
              )
              .toList(),
          onSelected: (Option? value) {
            onChanged?.call(value);
          },
        );
      },
    );
  }
}
