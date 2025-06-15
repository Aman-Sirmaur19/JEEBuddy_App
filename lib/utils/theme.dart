import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Fredoka',
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: Color(0xFFF5F5F3),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.orange),
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: Colors.white,
    hourMinuteTextColor: Colors.orange,
    dialHandColor: Colors.orange,
    dialBackgroundColor: Colors.orange.shade50,
    entryModeIconColor: Colors.orange,
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: Colors.white,
    headerBackgroundColor: Colors.orange,
    headerForegroundColor: Colors.white,
    todayBorder: const BorderSide(color: Colors.orange),
    todayForegroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected) ? Colors.white : Colors.black),
    todayBackgroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.orange
            : Colors.transparent),
    dayForegroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected) ? Colors.white : Colors.black),
    dayBackgroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.orange
            : Colors.transparent),
    yearForegroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected) ? Colors.white : Colors.black),
    yearBackgroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.orange
            : Colors.transparent),
  ),
  colorScheme: const ColorScheme.light(
    background: Color(0xFFF5F5F3),
    primary: Colors.white,
    secondary: Colors.black,
    tertiary: Colors.white,
    primaryContainer: Color(0xFFE5E5E4),
    secondaryContainer: Colors.black54,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.orange,
    selectionHandleColor: Colors.orange,
    selectionColor: Colors.orange.withOpacity(0.4),
  ),
  iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.black))),
  useMaterial3: true,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Fredoka',
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.black,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.orange),
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: Colors.grey[900],
    hourMinuteTextColor: Colors.orange,
    dialHandColor: Colors.orange,
    dialBackgroundColor: Colors.black12,
    entryModeIconColor: Colors.orange,
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: Colors.grey[900],
    headerBackgroundColor: Colors.orange,
    headerForegroundColor: Colors.white,
    todayBorder: const BorderSide(color: Colors.orange),
    todayForegroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.grey.shade300),
    todayBackgroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.orange
            : Colors.transparent),
    dayForegroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.grey.shade300),
    dayBackgroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.orange
            : Colors.transparent),
    yearForegroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.grey.shade300),
    yearBackgroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.orange
            : Colors.transparent),
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.grey.shade900,
    secondary: Colors.white,
    tertiary: const Color(0xFF636366),
    primaryContainer: const Color(0xFF1C1C1F),
    secondaryContainer: const Color(0xFF636366),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.orange,
    selectionHandleColor: Colors.orange,
    selectionColor: Colors.orange.withOpacity(0.4),
  ),
  iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.white))),
  useMaterial3: true,
);
