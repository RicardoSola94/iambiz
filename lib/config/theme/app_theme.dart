import 'package:flutter/material.dart';
import 'package:iambiz/config/colors.dart';

//const seedColor = Color.fromARGB(255, 7, 80, 59);

class AppTheme {
  final bool isDarkmode;

  AppTheme({required this.isDarkmode});

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.primaryColor,
    brightness: isDarkmode ? Brightness.dark : Brightness.light,

    listTileTheme: const ListTileThemeData(iconColor: AppColors.primaryColor),
  );
}
