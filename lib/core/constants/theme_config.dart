import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF42A5F5), // Blue 400
      onPrimary: Colors.white,
      secondary: const Color(0xFF90CAF9), // Blue 200
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.black87,
      surface: Colors.white,
      onSurface: Colors.black87,
    ),
    scaffoldBackgroundColor: const Color(0xFFF0F2F5), // Light grey background
    textTheme: TextTheme(
      titleLarge: GoogleFonts.poppins(
        fontSize: 28, // Slightly larger for impact
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2C3E50), // Darker text for contrast
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF34495E),
      ),
      bodyLarge: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
      labelLarge:
          GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF42A5F5),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8, // Increased elevation for a modern feel
        shadowColor: const Color(0xFF42A5F5).withOpacity(0.3),
        padding: const EdgeInsets.symmetric(
            horizontal: 24, vertical: 12), // Larger padding
      ).copyWith(
        overlayColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.1)),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 6, // Slightly less elevation but still noticeable
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      surfaceTintColor: Colors.transparent, // Use transparent for light theme
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none), // Softer borders
      filled: true,
      fillColor: const Color(0xFFE8EEF4), // Lighter fill color
      prefixIconColor: const Color(0xFF42A5F5),
      hintStyle: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF42A5F5), // Primary color for app bar
      elevation: 0, // Flat design
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF42A5F5),
      unselectedItemColor: Colors.grey[500],
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle:
          GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
      elevation: 10,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF90CAF9), // Lighter blue for dark theme
      onPrimary: Colors.black,
      secondary: const Color(0xFF64B5F6), // Darker blue
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.black,
      background: const Color(0xFF1A1A2E), // Deep dark background
      onBackground: Colors.white70,
      surface: const Color(0xFF2C2C4B), // Slightly lighter surface
      onSurface: Colors.white70,
    ),
    scaffoldBackgroundColor: const Color(0xFF1A1A2E),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
      bodyLarge: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
      labelLarge:
          GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF90CAF9),
        foregroundColor: Colors.black87, // Dark text on light button
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        shadowColor: const Color(0xFF90CAF9).withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ).copyWith(
        overlayColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.1)),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF2C2C4B),
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      filled: true,
      fillColor: const Color(0xFF3A3A5A), // Darker fill color
      prefixIconColor: const Color(0xFF90CAF9),
      hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1A1A2E), // Dark background for app bar
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF2C2C4B),
      selectedItemColor: const Color(0xFF90CAF9),
      unselectedItemColor: Colors.grey[600],
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle:
          GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
      elevation: 10,
    ),
  );
}
