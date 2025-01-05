import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

void showCustomSnackbar({
  required String title,
  required String message,
  IconData? icon,
  Color? backgroundColor = const Color.fromARGB(255, 221, 216, 216),
  Color textColor = Colors.black,
  Color? iconColor,
  SnackPosition snackPosition = SnackPosition.BOTTOM,
  Duration duration = const Duration(seconds: 3),
  double borderRadius = 2.0,
  EdgeInsets margin = const EdgeInsets.all(10.0),
  EdgeInsets padding = const EdgeInsets.all(16.0),
  TextAlign textAlign = TextAlign.center,
  bool isDismissible = true,
  Function? onTap,
}) {
  Get.snackbar(
    title,
    message,
    icon: icon != null
        ? Icon(icon, color: iconColor ?? textColor, size: 24.0)
        : null,
    backgroundColor: backgroundColor!.withValues(alpha: 178),
    colorText: textColor,
    snackPosition: snackPosition,
    duration: duration,
    borderRadius: borderRadius,
    margin: margin,
    padding: padding,
    snackStyle: SnackStyle.FLOATING, // This makes it float above other widgets
    overlayBlur: 3, // Adding a slight blur to the background
    overlayColor: Colors.black.withOpacity(0.4),
    isDismissible: isDismissible,
    onTap: (_) {
      if (onTap != null) onTap();
    },
    messageText: Text(
      message,
      textAlign: textAlign,
      style: AppTextStyles.montserratBold.copyWith(color: textColor),
    ),
    titleText: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: textColor,
        fontSize: 16,
      ),
    ),
  );
}
