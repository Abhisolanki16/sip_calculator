import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? disabledColor;
  final Color? borderColor;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final bool isLoading;
  final double elevation;
  final MainAxisAlignment alignment; // for icon+text alignment
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.textStyle,
    this.backgroundColor,
    this.disabledColor,
    this.borderColor,
    this.borderRadius = 12,
    this.borderWidth = 1,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.isLoading = false,
    this.elevation = 0,
    this.alignment = MainAxisAlignment.center,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          backgroundColor: onPressed == null
              ? disabledColor ?? Colors.grey
              : backgroundColor ?? theme.primaryColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderWidth,
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textStyle?.color ?? Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: alignment,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: iconSize ?? 20,
                      color: iconColor ?? textStyle?.color ?? Colors.white,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style:
                        textStyle ??
                        theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
