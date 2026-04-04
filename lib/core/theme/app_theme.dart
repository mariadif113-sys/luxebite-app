import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Royal Luxury Palette
  static const Color obsidian = Color(0xFF120A21); // Deep Royal Velvet Dark
  static const Color cardDark = Color(0xFF23153C); // Rich Plum Purple
  static const Color gold = Color(0xFFD4AF37);     // Imperial Gold
  static const Color azure = Color(0xFF4B0082);    // Indigo/Royal Accent
  static const Color cream = Color(0xFFFDFBF7);    // Pearl Cream

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: gold,
      scaffoldBackgroundColor: obsidian,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: azure,
        surface: cardDark,
        onPrimary: obsidian,
        onSurface: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: gold,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: gold,
      scaffoldBackgroundColor: cream,
      colorScheme: const ColorScheme.light(
        primary: gold,
        secondary: azure,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: obsidian,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: obsidian,
          height: 1.1,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: obsidian,
        ),
      ),
    );
  }
}
