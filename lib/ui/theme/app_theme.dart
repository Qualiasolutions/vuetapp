import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-wide theme settings and color constants
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Riverpod provider for the current theme
  static final appThemeProvider = Provider<ThemeData>((ref) {
    // For now, just return the light theme.
    // Future: Add logic here to switch between light/dark based on system or user preference.
    return AppTheme.lightTheme;
  });

  /// Primary brand color (Dark Jungle Green)
  static const Color primary = Color(0xFF203F39);

  /// Secondary brand color (Dark Teal)
  static const Color secondary = Color(0xFF005D63);

  /// Accent color (Orange)
  static const Color accent = Color(0xFFE39F2F);

  /// Steel color for text
  static const Color steel = Color(0xFF79858D);

  /// Error color
  static const Color error = Color(0xFFB00020);

  /// Success color
  static const Color success = Color(0xFF4CAF50);

  /// Warning color
  static const Color warning = Color(0xFFFFC107);

  /// Info color
  static const Color info = Color(0xFF2196F3);

  /// Share color for notifications
  static const Color shareColor = Color(0xFF9C27B0);

  /// Update color for notifications
  static const Color updateColor = Color(0xFF3F51B5);

  /// Comment color for notifications
  static const Color commentColor = Color(0xFF00BCD4);

  /// Color for low priority tasks (using secondary/turquoise)
  static const Color lowPriorityColor = secondary;

  /// Color for medium priority tasks (Orange)
  static const Color mediumPriorityColor = accent;

  /// Color for high priority tasks (using primary for importance)
  static const Color highPriorityColor = primary;

  /// Color for completed tasks
  static const Color completedColor =
      Color(0xFF4CAF50); // Keep original for now

  /// Light text color, used often on colored backgrounds (White)
  static const Color textLight = Color(0xFFFFFFFF);

  /// Notification unread indicator color
  static const Color notificationUnreadColor =
      Color(0xFFE91E63); // Keep original for now

  /// Primary color alias
  static const Color primaryColor = primary;

  /// Success color alias
  static const Color successColor = success; // Keep original for now

  /// Primary text color (Dark Jungle Green)
  static const Color textPrimary = Color(0xFF203F39);

  /// Secondary text color (Steel)
  static const Color textSecondary = steel;

  /// Disabled text color
  static const Color textDisabled = Color(0xFFBDBDBD); // Keep original for now

  /// Background color for cards (White)
  static const Color cardBackground = Color(0xFFFFFFFF);

  /// Background color for screens (White)
  static const Color background = Color(0xFFFFFFFF);

  /// App bar color (Medium Turquoise - making it the main color)
  static const Color appBarColor = secondary;

  /// Get color for task priority
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return lowPriorityColor;
      case 'medium':
        return mediumPriorityColor;
      case 'high':
        return highPriorityColor;
      default:
        return mediumPriorityColor;
    }
  }

  /// Get color for task status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return completedColor;
      case 'in_progress':
      case 'in progress':
        return info;
      case 'on_hold':
      case 'on hold':
        return warning;
      case 'cancelled':
        return error;
      case 'pending':
        return textSecondary;
      default:
        return textSecondary;
    }
  }

  /// Get the light theme data
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true, // Enable Material 3 design system
    primaryColor: secondary,
    colorScheme: ColorScheme.light(
      primary: secondary,
      secondary: primary,
      tertiary: accent,
      surface: background,
      error: error,
      onPrimary: textLight,
      onSecondary: textLight,
      onSurface: textPrimary,
      onError: textLight,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: appBarColor,
      foregroundColor: textLight,
      elevation: 0, // Flat design
      centerTitle: false,
      titleTextStyle: const TextStyle(
        color: textLight,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(
        color: textLight,
        size: 24,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secondary,
      foregroundColor: textLight,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondary,
        foregroundColor: textLight,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: secondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: secondary,
        side: const BorderSide(color: secondary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: textSecondary.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: secondary, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: textSecondary.withValues(alpha: 0.2)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      hintStyle: TextStyle(color: textSecondary.withValues(alpha: 0.7)),
      labelStyle: const TextStyle(color: textPrimary),
    ),
    cardTheme: const CardThemeData(
      color: cardBackground,
      elevation: 2,
      shadowColor: Color.fromRGBO(0, 0, 0, 0.1), // Fixed for CardThemeData
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return secondary;
        }
        return Colors.transparent;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return secondary;
        }
        return Colors.grey.shade400;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return secondary.withValues(alpha: 0.5);
        }
        return Colors.grey.shade300;
      }),
    ),
    scaffoldBackgroundColor: background,
    dividerColor: Colors.grey.shade200,
    dividerTheme: const DividerThemeData(
      space: 20,
      thickness: 1,
    ),
    fontFamily: 'Roboto',
    textTheme:
        GoogleFonts.robotoTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: const TextStyle(
          color: textPrimary, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: const TextStyle(
          color: textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: const TextStyle(
          color: textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
      headlineLarge: const TextStyle(
          color: textPrimary, fontSize: 22, fontWeight: FontWeight.w600),
      headlineMedium: const TextStyle(
          color: textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
      headlineSmall: const TextStyle(
          color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
      titleLarge: const TextStyle(
          color: textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
      titleMedium: const TextStyle(
          color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
      titleSmall: const TextStyle(
          color: textPrimary, fontSize: 12, fontWeight: FontWeight.w500),
      bodyLarge: const TextStyle(color: textPrimary, fontSize: 16),
      bodyMedium: const TextStyle(color: textPrimary, fontSize: 14),
      bodySmall: TextStyle(color: textSecondary, fontSize: 12),
      labelLarge: const TextStyle(
          color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(
          color: textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(
          color: textSecondary, fontSize: 10, fontWeight: FontWeight.w500),
    ),
    iconTheme: const IconThemeData(
      color: textPrimary,
      size: 24,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: secondary,
      unselectedItemColor: textSecondary,
      backgroundColor: background,
      elevation: 8,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: secondary,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: textSecondary,
      ),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade100,
      disabledColor: Colors.grey.shade300,
      selectedColor: secondary.withValues(alpha: 0.2),
      secondarySelectedColor: accent.withValues(alpha: 0.2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(fontSize: 14),
      secondaryLabelStyle: const TextStyle(fontSize: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );

  /// Get the dark theme data
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: secondary,
    colorScheme: ColorScheme.dark(
      primary: secondary,
      secondary: primary,
      tertiary: accent,
      surface: Color(0xFF1E1E1E),
      error: error,
      onPrimary: textLight,
      onSecondary: textLight,
      onSurface: textLight,
      onError: textLight,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: secondary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secondary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondary,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: secondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: secondary,
        side: const BorderSide(color: secondary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade900,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: secondary, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF1E1E1E),
      elevation: 2,
      shadowColor: Color.fromRGBO(0, 0, 0, 0.3), // Fixed for CardThemeData
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      tileColor: Color(0xFF1E1E1E),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return secondary;
        }
        return Colors.transparent;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return secondary;
        }
        return Colors.grey.shade700;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return secondary.withValues(alpha: 0.5);
        }
        return Colors.grey.shade800;
      }),
    ),
    scaffoldBackgroundColor: Color(0xFF121212),
    dividerColor: Colors.grey.shade800,
    dividerTheme: const DividerThemeData(
      space: 20,
      thickness: 1,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: secondary,
      unselectedItemColor: Colors.grey.shade400,
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 8,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade800,
      disabledColor: Colors.grey.shade700,
      selectedColor: secondary.withValues(alpha: 0.2),
      secondarySelectedColor: accent.withValues(alpha: 0.2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(fontSize: 14),
      secondaryLabelStyle: const TextStyle(fontSize: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    fontFamily: 'Roboto',
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: const TextStyle(
          color: textLight, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: const TextStyle(
          color: textLight, fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: const TextStyle(
          color: textLight, fontSize: 24, fontWeight: FontWeight.bold),
      headlineLarge: const TextStyle(
          color: textLight, fontSize: 22, fontWeight: FontWeight.w600),
      headlineMedium: const TextStyle(
          color: textLight, fontSize: 20, fontWeight: FontWeight.w600),
      headlineSmall: const TextStyle(
          color: textLight, fontSize: 18, fontWeight: FontWeight.w600),
      titleLarge: const TextStyle(
          color: textLight, fontSize: 16, fontWeight: FontWeight.w600),
      titleMedium: const TextStyle(
          color: textLight, fontSize: 14, fontWeight: FontWeight.w500),
      titleSmall: const TextStyle(
          color: textLight, fontSize: 12, fontWeight: FontWeight.w500),
      bodyLarge: const TextStyle(color: textLight, fontSize: 16),
      bodyMedium: const TextStyle(color: textLight, fontSize: 14),
      bodySmall: TextStyle(color: Colors.grey.shade400, fontSize: 12),
      labelLarge: const TextStyle(
          color: textLight, fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 12,
          fontWeight: FontWeight.w500),
      labelSmall: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 10,
          fontWeight: FontWeight.w500),
    ),
  );
}
