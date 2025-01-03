import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final double elevation;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.backgroundColor = const Color.fromARGB(255, 3, 37, 32),
    this.elevation = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTextStyles.montserratBold),
      centerTitle: false,
      backgroundColor: backgroundColor,
      elevation: elevation,
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
