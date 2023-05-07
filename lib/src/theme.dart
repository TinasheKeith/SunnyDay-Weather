import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
    primaryColor: const Color(0xFF213056),
    canvasColor: const Color(0xFFF5F5F5),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      displayLarge: GoogleFonts.lato(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
      displayMedium: GoogleFonts.lato(
        fontSize: 20,
        fontWeight: FontWeight.w200,
        color: Colors.blueGrey,
      ),
      displaySmall: GoogleFonts.lato(
        fontSize: 80,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
      headlineMedium: GoogleFonts.lato(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
      titleMedium: GoogleFonts.lato(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
      titleSmall: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: Colors.orange,
      ),
      bodyLarge: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyMedium: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFFFFA500),
    ),
  );
}
