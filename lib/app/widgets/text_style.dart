import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextStyle montserratBold = GoogleFonts.montserrat(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  static final TextStyle montserratRegular = GoogleFonts.montserrat(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
  );

  static final TextStyle montserratLight = GoogleFonts.montserrat(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: Colors.grey,
    ),
  );
  static final TextStyle headline = GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );

  static final TextStyle bodyText = GoogleFonts.roboto(
    textStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
  );

  static final TextStyle caption = GoogleFonts.openSans(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w300,
      color: Colors.blueGrey,
    ),
  );
}