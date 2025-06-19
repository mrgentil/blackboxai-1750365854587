import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final EdgeInsets? contentPadding;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? initialValue;
  final bool isDense;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.contentPadding,
    this.autofocus = false,
    this.focusNode,
    this.initialValue,
    this.isDense = false,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveFillColor = fillColor ?? theme.cardColor;

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onTap: onTap,
      validator: validator,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      minLines: minLines,
      autofocus: autofocus,
      focusNode: focusNode,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: enabled ? null : theme.disabledColor,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        isDense: isDense,
        filled: true,
        fillColor: enabled ? effectiveFillColor : theme.disabledColor.withOpacity(0.1),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: enabled
                    ? Constants.primaryColor
                    : theme.disabledColor,
              )
            : null,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(
          horizontal: Constants.defaultPadding,
          vertical: Constants.smallPadding,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.defaultBorderRadius),
          borderSide: BorderSide(
            color: theme.dividerColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.defaultBorderRadius),
          borderSide: BorderSide(
            color: theme.dividerColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.defaultBorderRadius),
          borderSide: BorderSide(
            color: Constants.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.defaultBorderRadius),
          borderSide: BorderSide(
            color: Constants.errorColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.defaultBorderRadius),
          borderSide: BorderSide(
            color: Constants.errorColor,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.defaultBorderRadius),
          borderSide: BorderSide(
            color: theme.disabledColor.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

// Extension for common text field variants
extension CustomTextFieldVariants on CustomTextField {
  static CustomTextField email({
    TextEditingController? controller,
    String? hintText = 'Email',
    String? labelText = 'Email',
    bool enabled = true,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'L\'email est requis';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Email invalide';
        }
        return null;
      },
      prefixIcon: Icons.email,
    );
  }

  static CustomTextField password({
    TextEditingController? controller,
    String? hintText = 'Mot de passe',
    String? labelText = 'Mot de passe',
    bool enabled = true,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    bool obscureText = true,
    Widget? suffixIcon,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      enabled: enabled,
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      onChanged: onChanged,
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Le mot de passe est requis';
        }
        if (value.length < 8) {
          return 'Le mot de passe doit contenir au moins 8 caractères';
        }
        return null;
      },
      prefixIcon: Icons.lock,
      suffixIcon: suffixIcon,
    );
  }

  static CustomTextField phone({
    TextEditingController? controller,
    String? hintText = 'Téléphone',
    String? labelText = 'Téléphone',
    bool enabled = true,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      validator: validator,
      prefixIcon: Icons.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  static CustomTextField search({
    TextEditingController? controller,
    String? hintText = 'Rechercher',
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      onTap: onTap,
      prefixIcon: Icons.search,
      isDense: true,
    );
  }
}
