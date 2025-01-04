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
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffixicon,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}
