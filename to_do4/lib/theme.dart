import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final appTheme = ThemeData(
  primaryColor: Color.fromRGBO(243, 170, 78, 1),
  primaryColorDark: Color.fromRGBO(18, 24, 32, 1),
  textTheme: TextTheme(
    bodyMedium: GoogleFonts.robotoMono(
      color:Color.fromRGBO(243, 170, 78, 1),
      fontSize: 20,
      fontWeight: FontWeight.w900
    ),
    labelSmall: GoogleFonts.robotoMono(
      color: Color.fromRGBO(18, 24, 32, 1),
      // color: Colors.white,
      fontWeight: FontWeight.w300,
      fontSize: 20
    )
  )
);