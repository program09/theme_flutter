import 'package:flutter/material.dart';
import 'package:ui/widgets/forms/input.dart';
import 'package:ui/widgets/forms/options.dart';

class InputAutocompleteUI extends StatefulWidget {
  final String label;
  final String hintText;
  final String? errorText;
  final TextEditingController controller;
  final bool disabled;
  final TextInputType type;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final List<Option>? options;
  final AutocompleteOptionsBuilder<Option>? optionsBuilder;
  final void Function(Option)? onSelected;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSubmitted;

  const InputAutocompleteUI({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.disabled = false,
    this.type = TextInputType.text,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.options,
    this.optionsBuilder,
    this.onSelected,
    this.onChanged,
    this.validator,
    this.onSubmitted,
  });

  @override
  State<InputAutocompleteUI> createState() => _InputAutocompleteUIState();
}

class _InputAutocompleteUIState extends State<InputAutocompleteUI> {
  bool isPasswordVisible = false;

  Widget? icon() {
    return widget.type == Type.password
        ? IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          )
        : widget.suffixIcon != null
        ? Icon(widget.suffixIcon)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Option>(
      displayStringForOption: (Option option) => option.label,
      optionsBuilder:
          widget.optionsBuilder ??
          (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<Option>.empty();
            }
            return (widget.options ?? []).where((Option option) {
              return option.label.toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              );
            });
          },
      onSelected: widget.onSelected,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              enabled: !widget.disabled,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                labelText: widget.label,
                labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                hintText: widget.type == Type.password
                    ? '••••••••'
                    : widget.hintText,
                errorText: widget.errorText,
                prefixIcon: widget.prefixIcon != null
                    ? Icon(widget.prefixIcon)
                    : null,
                suffixIcon: icon(),
              ),
              keyboardType: widget.type,
              obscureText: widget.type == Type.password && !isPasswordVisible,
              maxLines: widget.type == Type.multiline ? 3 : 1,
              onChanged: widget.onChanged,
              validator: widget.validator,
              onFieldSubmitted: (value) {
                onFieldSubmitted();
                if (widget.onSubmitted != null) {
                  widget.onSubmitted!(value);
                }
              },
            );
          },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 64,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final Option option = options.elementAt(index);
                  return ListTile(
                    title: Text(option.label),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
