// custom_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final EdgeInsets? padding;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.padding,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width ?? double.infinity,
        child: isOutlined
            ? OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
                child: Text(text),
              )
            : ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  text,
                  style: TextStyle(color: textColor),
                ),
              ),
      );
}
