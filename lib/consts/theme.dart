import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Tema renkleri
class AppColors {
  static const Color primaryLight = Color(0xFF00F2EA);
  static const Color primaryDark = Color(0xFF00D2FF);
  static const Color secondaryLight = Color(0xFFFF0050);
  static const Color secondaryDark = Color(0xFFFF3B70);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFF0F0F0);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFF000000);
  static const Color textDark = Color(0xFFFFFFFF);
}

// Tema tanımlamaları
class AppTheme {
  static final ThemeData theme = ThemeData(
    primaryColor: Color(0xFF1E88E5), // Koyu arka plan
    scaffoldBackgroundColor: Color(0xFF121212),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
      ),
      bodyMedium: TextStyle(
        color: Colors.white70,
        fontSize: 14.sp,
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
      size: 24.sp,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF1E88E5),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white10,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.white54),
    ),
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: Color(0xFFFFA000))
        .copyWith(background: Color(0xFF121212)),
  );
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      surface: AppColors.surfaceLight,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onSurface: AppColors.textLight,
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryLight,
      iconTheme: IconThemeData(color: AppColors.textLight),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textLight),
      bodyMedium: TextStyle(color: AppColors.textLight),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      surface: AppColors.surfaceDark,
      onPrimary: AppColors.textDark,
      onSecondary: AppColors.textDark,
      onSurface: AppColors.textDark,
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryDark,
      iconTheme: IconThemeData(color: AppColors.textDark),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textDark),
      bodyMedium: TextStyle(color: AppColors.textDark),
    ),
  );
}

// Tema kontrolcüsü
class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;

  bool _loadTheme() => _box.read(_key) ?? false;

  void saveTheme(bool isDarkMode) => _box.write(_key, isDarkMode);

  void changeTheme(ThemeData theme) => Get.changeTheme(theme);

  void changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);
}

// Tema değiştirme butonu için örnek widget
class ThemeToggle extends StatelessWidget {
  final ThemeController themeController = Get.find();

  ThemeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ThemeMode>(
      icon: const Icon(Icons.brightness_6),
      onSelected: (ThemeMode selectedMode) {
        if (selectedMode == ThemeMode.system) {
          themeController.changeThemeMode(ThemeMode.system);
        } else {
          themeController.changeThemeMode(selectedMode == ThemeMode.dark
              ? ThemeMode.dark
              : ThemeMode.light);
          themeController.saveTheme(selectedMode == ThemeMode.dark);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
        const PopupMenuItem<ThemeMode>(
          value: ThemeMode.light,
          child: Text('Light Theme'),
        ),
        const PopupMenuItem<ThemeMode>(
          value: ThemeMode.dark,
          child: Text('Dark Theme'),
        ),
        const PopupMenuItem<ThemeMode>(
          value: ThemeMode.system,
          child: Text('System Theme'),
        ),
      ],
    );
  }
}
