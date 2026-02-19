import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const bgColor = Color(0xFF050505);
  static const glassBg = Color(0xFF141414);
  static const accentPrimary = Color(0xFF00F2FF); // Cyan
  static const accentSecondary = Color(0xFF7000FF); // Purple
  static const accentGreen = Color(0xFF00FF88);
  static const textMain = Color(0xFFE0E0E0);
  static const textDim = Color(0xFF888888);
  static const cardBorder = Color(0xFF1A1A1A);

  // Gradients
  static const neonGradient = LinearGradient(
    colors: [accentPrimary, accentSecondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const bgGradient = LinearGradient(
    colors: [Color(0xFF0D0D0D), Color(0xFF050505)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> neonShadow({Color color = accentPrimary}) => [
    BoxShadow(color: color.withOpacity(0.3), blurRadius: 20, spreadRadius: 1),
  ];

  // Card decoration
  static BoxDecoration glassCard({Color? borderColor}) => BoxDecoration(
    color: glassBg.withOpacity(0.8),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: borderColor ?? Colors.white.withOpacity(0.07),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
  );

  // Input decoration
  static InputDecoration neonInput(
    String label, {
    String? hint,
    IconData? icon,
  }) => InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(color: textDim, fontSize: 13),
    hintStyle: TextStyle(color: textDim.withOpacity(0.5), fontSize: 13),
    prefixIcon: icon != null ? Icon(icon, color: textDim, size: 20) : null,
    filled: true,
    fillColor: Colors.white.withOpacity(0.04),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: accentPrimary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
  );

  static ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgColor,
    colorScheme: const ColorScheme.dark(
      primary: accentPrimary,
      secondary: accentSecondary,
      surface: glassBg,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: textMain,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.orbitron(
        color: textMain,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: GoogleFonts.orbitron(
        color: textMain,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.orbitron(
        color: textMain,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.inter(color: textMain),
      bodyMedium: GoogleFonts.inter(color: textMain),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.orbitron(
        color: textMain,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: textMain),
    ),
    useMaterial3: true,
  );
}
