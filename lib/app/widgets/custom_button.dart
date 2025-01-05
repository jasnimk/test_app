// // custom_button.dart
// import 'package:flutter/material.dart';

// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final Color? backgroundColor;
//   final Color? textColor;
//   final double? width;
//   final EdgeInsets? padding;
//   final bool isOutlined;

//   const CustomButton({
//     super.key,
//     required this.text,
//     this.onPressed,
//     this.backgroundColor,
//     this.textColor,
//     this.width,
//     this.padding,
//     this.isOutlined = false,
//   });

//   @override
//   Widget build(BuildContext context) => SizedBox(
//         width: width ?? double.infinity,
//         child: isOutlined
//             ? OutlinedButton(
//                 onPressed: onPressed,
//                 style: OutlinedButton.styleFrom(
//                   padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
//                   side: BorderSide(color: Theme.of(context).primaryColor),
//                 ),
//                 child: Text(text),
//               )
//             : ElevatedButton(
//                 onPressed: onPressed,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: backgroundColor,
//                   padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: Text(
//                   text,
//                   style: TextStyle(color: textColor),
//                 ),
//               ),
//       );
// }
import 'package:flutter/material.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final EdgeInsets? padding;
  final bool isOutlined;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.padding,
    this.isOutlined = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    )
                  : Text(text),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      text,
                      style: AppTextStyles.montserratBold
                          .copyWith(fontSize: 14, color: Colors.white),
                    ),
            ),
    );
  }
}
