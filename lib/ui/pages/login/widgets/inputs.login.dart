import 'package:flutter/material.dart';
import 'package:capital_tours_mobile/widgets/colors.dart';

class InputLogin extends StatelessWidget {
  final FocusNode? focusNode;
  final bool? isEnabled;
  final bool? enabled;
  final bool? enableInteractiveSelection;
  final bool? filled;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final Color? cursorColor;
  final InputDecoration? decoration;
  final bool obscureText;
  final Icon? prefixIcon; // Cambiado a Icon
  final Icon? suffixIcon;
  final Widget? icon; // Nuevo parámetro para la imagen o icono
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintext;
  final TextStyle? hintStyle;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const InputLogin({
    super.key,
    this.decoration,
    required this.focusNode,
    this.isEnabled,
    this.enabled,
    this.enableInteractiveSelection,
    this.filled,
    this.keyboardType,
    this.fillColor,
    this.style,
    this.hintStyle,
    this.cursorColor,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.icon,
    required this.labelText,
    this.labelStyle,
    this.hintext,
    this.onFieldSubmitted,
    this.validator,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        enabled: isEnabled ?? enabled ?? true,
        enableInteractiveSelection: enableInteractiveSelection,
        keyboardType: keyboardType,
        style: style,
        cursorColor: cursorColor,
        focusNode: focusNode,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.0,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(
              width: 1,
              color: dangerColor,
            ),
          ),
          errorStyle: const TextStyle(color: dangerColor),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          prefixIcon: icon ?? prefixIcon,
          suffixIcon: icon ?? suffixIcon,
          hintText: hintext,
          hintStyle: hintStyle,
          labelText: labelText,
          labelStyle: labelStyle,
        ),
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        onChanged: onChanged,
        controller: controller,
      ),
    );
  }
}