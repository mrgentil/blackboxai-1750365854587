import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isSecondary;
  final bool isSmall;
  final bool isFullWidth;
  final EdgeInsets? padding;
  final double? borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.isSecondary = false,
    this.isSmall = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  const CustomButton.secondary({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.isSmall = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
  })  : isSecondary = true,
        super(key: key);

  const CustomButton.small({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.isSecondary = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
  })  : isSmall = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultHeight = isSmall ? 36.0 : 48.0;
    final defaultPadding = isSmall
        ? const EdgeInsets.symmetric(horizontal: 16.0)
        : const EdgeInsets.symmetric(horizontal: 24.0);
    final fontSize = isSmall ? 14.0 : 16.0;

    final style = isSecondary
        ? Constants.secondaryButtonStyle.copyWith(
            backgroundColor: MaterialStateProperty.all(
              backgroundColor ?? Colors.transparent,
            ),
            foregroundColor: MaterialStateProperty.all(
              textColor ?? Constants.primaryColor,
            ),
            padding: MaterialStateProperty.all(
              padding ?? defaultPadding,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? Constants.defaultBorderRadius,
                ),
                side: BorderSide(
                  color: textColor ?? Constants.primaryColor,
                ),
              ),
            ),
          )
        : Constants.primaryButtonStyle.copyWith(
            backgroundColor: MaterialStateProperty.all(
              backgroundColor ?? Constants.primaryColor,
            ),
            foregroundColor: MaterialStateProperty.all(
              textColor ?? Colors.white,
            ),
            padding: MaterialStateProperty.all(
              padding ?? defaultPadding,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? Constants.defaultBorderRadius,
                ),
              ),
            ),
          );

    final child = isLoading
        ? SizedBox(
            width: isSmall ? 16 : 24,
            height: isSmall ? 16 : 24,
            child: CircularProgressIndicator(
              strokeWidth: isSmall ? 2 : 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                isSecondary ? Constants.primaryColor : Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: isSmall ? 16 : 20,
                ),
                SizedBox(width: isSmall ? 4 : 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: child,
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        height: height ?? defaultHeight,
        child: button,
      );
    }

    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height ?? defaultHeight,
        child: button,
      );
    }

    return button;
  }
}
