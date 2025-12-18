import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginTheme {
  static const Color primaryBlue = Color(0xFF0266EA);
  static const Color accentGreen = Color(0xFFCFFFE0);
  static const Color textDark = Color(0xFF000000);
  
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0266EA), Color(0xFF0153C7)],
  );

  static TextStyle get headingStyle => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textDark,
  );
  
  static TextStyle get bodyStyle => GoogleFonts.poppins(
    fontSize: 14,
    color: textDark,
  );
}
