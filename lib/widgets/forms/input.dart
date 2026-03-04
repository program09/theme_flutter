import 'package:flutter/material.dart';

class Type {
  static const TextInputType text = TextInputType.text;
  static const TextInputType number = TextInputType.number;
  static const TextInputType email = TextInputType.emailAddress;
  static const TextInputType password = TextInputType.visiblePassword;
  static const TextInputType phone = TextInputType.phone;
  static const TextInputType multiline = TextInputType.multiline;
  static const TextInputType datetime = TextInputType.datetime;
  static const TextInputType url = TextInputType.url;
  static TextInputType numberWithOptions({
    bool signed = false,
    bool decimal = false,
  }) => TextInputType.numberWithOptions(signed: signed, decimal: decimal);
}

class InputUI extends StatefulWidget {
  final String label;
  final String hintText;
  final String? errorText;
  final TextEditingController controller;
  final bool disabled;
  final TextInputType type;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSubmitted;
  const InputUI({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.disabled = false,
    this.type = TextInputType.text,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.onSubmitted,
  });

  @override
  State<InputUI> createState() => _InputUIState();
}

class _InputUIState extends State<InputUI> {
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
    return TextFormField(
      controller: widget.controller,
      enabled: !widget.disabled,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        labelText: widget.label,
        labelStyle: TextStyle(fontWeight: FontWeight.w500),
        hintText: widget.type == Type.password ? '••••••••' : widget.hintText,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: icon(),
      ),
      keyboardType: widget.type,
      obscureText: widget.type == Type.password && !isPasswordVisible,
      maxLines: widget.type == Type.multiline ? 3 : 1,
      onChanged: widget.onChanged,
      validator: widget.validator,
      onFieldSubmitted: widget.onSubmitted,
    );
  }
}
