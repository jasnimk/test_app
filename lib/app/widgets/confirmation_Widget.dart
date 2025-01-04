import 'package:flutter/material.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDangerous;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.content,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.isDangerous = true,
  }) : super(key: key);

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isDangerous = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ConfirmationDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDangerous: isDangerous,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color dangerColor = const Color.fromARGB(255, 3, 37, 32);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(
        title,
        style: AppTextStyles.montserratBold.copyWith(
          fontSize: 20,
          color: isDangerous ? dangerColor : Theme.of(context).primaryColor,
        ),
      ),
      content: Text(
        content,
        style: AppTextStyles.bodyText.copyWith(fontSize: 14),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (onCancel != null) onCancel!();
            Navigator.of(context).pop(false);
          },
          child: Text(
            cancelText,
            style: AppTextStyles.bodyText,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isDangerous ? dangerColor : Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop(true);
          },
          child: Text(
            confirmText,
            style: AppTextStyles.bodyText.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
