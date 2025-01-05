// import 'package:flutter/material.dart';

// class CustomTextFormField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String? Function(String?) validator;
//   final TextInputType keyboardType;
//   final bool obscureText;
//   final String? hint;
//   final Widget? suffixicon;
//     final Widget? prefixIcon;

//   const CustomTextFormField({
//     Key? key,
//     required this.controller,
//     required this.label,
//     required this.validator,
//     this.keyboardType = TextInputType.text,
//     this.obscureText = false,
//     this.hint,
//     this.suffixicon,
//     this.prefixIcon
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText:hint ,
//         suffixIcon: suffixicon,
//         prefixIcon: prefixIcon,
//         border: OutlineInputBorder(),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Theme.of(context).primaryColor),
//         ),
//       ),
//       validator: validator,
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? hint;
  final Widget? suffixicon;
  final Widget? prefixIcon;
  final Function(String)? onChanged;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.label,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.hint,
    this.suffixicon,
    this.prefixIcon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: AppTextStyles.montserratBold.copyWith(
        color: Colors.white, // Customize the input text color
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.caption.copyWith(
            color: const Color.fromARGB(255, 215, 210, 210), fontSize: 12),
        hintText: hint,
        suffixIcon: suffixicon,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: const Color.fromARGB(
                  255, 178, 174, 174)), // Border color when not focused
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white), // Border color when focused
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red), // Border color for error
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red), // Focused error border
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}
