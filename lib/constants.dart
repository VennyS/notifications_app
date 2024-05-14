import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
  useMaterial3: true,
  fontFamily: 'Roboto',
  iconTheme: const IconThemeData(size: 40, color: Color.fromRGBO(0, 0, 0, 0.6)),
  primaryIconTheme:
      const IconThemeData(color: Color.fromRGBO(166, 172, 208, 1)),
  cardTheme: const CardTheme(
    elevation: 0,
  ),
  chipTheme: const ChipThemeData(
    disabledColor: Color.fromRGBO(225, 227, 241, 1),
    selectedColor: Color.fromRGBO(173, 181, 236, 1),
    checkmarkColor: Color.fromRGBO(0, 0, 0, 0.9),
    side: BorderSide.none,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all(const Color.fromRGBO(173, 181, 236, 1)),
    elevation: MaterialStateProperty.all(0.0),
  )),
  colorScheme: const ColorScheme.light(
    primary: Color.fromRGBO(173, 181, 236, 1),
    secondary: Color.fromRGBO(225, 227, 241, 1),
    tertiary: Color.fromRGBO(226, 241, 225, 1),
    tertiaryContainer: Color.fromRGBO(225, 227, 241, 1),
  ),
  inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide:
            const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.1), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: Color.fromRGBO(93, 107, 205, 1), width: 2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      floatingLabelStyle: const TextStyle(
        color: Color.fromRGBO(93, 107, 205, 1),
        fontWeight: FontWeight.w400,
        fontSize: 16,
        letterSpacing: 0.4,
      ),
      labelStyle: const TextStyle(
        color: Color.fromRGBO(0, 0, 0, 0.6),
        fontWeight: FontWeight.w400,
        fontSize: 16,
        letterSpacing: 0.15,
      )),
  hintColor: const Color.fromRGBO(0, 0, 0, 0.2),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 22 / 22,
      color: Color.fromRGBO(0, 0, 0, 1),
    ),
    displayMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 22 / 22,
      color: Color.fromRGBO(0, 0, 0, 1),
    ),
    displaySmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 22 / 22,
      color: Color.fromRGBO(160, 162, 178, 1),
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      height: 22 / 22,
      color: Color.fromRGBO(0, 0, 0, 1),
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      height: 24 / 22,
      color: Color.fromRGBO(0, 0, 0, 0.6),
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 20 / 22,
      color: Color.fromRGBO(0, 0, 0, 0.6),
    ),
    bodyLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 20 / 22,
      letterSpacing: 0.25,
      color: Color.fromRGBO(0, 0, 0, 0.62),
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 18.75 / 18.75,
      color: Color.fromRGBO(0, 0, 0, 1),
    ),
  ),
);
