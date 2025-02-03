import 'package:flutter/material.dart';

const Color primary = Color(0xFF008060); //Tropical Rain Forest
const Color secondary = Color(0xFFF4E1C1); //Sandy Beige 
const Color obsidian = Color(0xFF0B1215);
const Color ghostWhite = Color(0xFFFFFAFA);
const Color coffe = Color(0xFFA67B5B);
Color errorColor = const Color(0xFFE57373);

const double largeSize = 20;
const double mediumSize = 16;
const double smallSize = 12;

//ThemeData
//
ThemeData theme = ThemeData(
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
        fontSize: largeSize,
        color: obsidian,
        fontWeight: FontWeight.bold,
        fontFamily: 'Karla'),
    bodyMedium: TextStyle(
        fontSize: mediumSize,
        color: obsidian,
        fontWeight: FontWeight.bold,
        fontFamily: 'Karla'),
    bodySmall: TextStyle(
        fontSize: smallSize,
        color: obsidian,
        fontWeight: FontWeight.bold,
        fontFamily: 'Karla'),
    labelLarge: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: largeSize,
        color: obsidian,
        fontFamily: 'Karla'),
    labelMedium: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: mediumSize,
        color: obsidian,
        fontFamily: 'Karla'),
    labelSmall: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: smallSize,
        color: obsidian,
        fontFamily: 'Karla'),
  ),

  //SnackBarTheme
  //
  snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),

  //ScrollbarTheme
  //
  scrollbarTheme: const ScrollbarThemeData(
    trackVisibility: WidgetStatePropertyAll(true),
    interactive: true,
    thickness: WidgetStatePropertyAll(8),
    thumbVisibility: WidgetStatePropertyAll(true),
  ),

  //NavigationBarThemeData
  //
  navigationBarTheme: const NavigationBarThemeData(
      labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: smallSize))),

  //ColorScheme
  //
  colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: secondary,
      error: Colors.red),

  //InputDecorationTheme
  //
  inputDecorationTheme: const InputDecorationTheme(
    focusColor: obsidian,
    labelStyle: TextStyle(color: obsidian),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: obsidian),
    ),
  ),
  //TextSelectionTheme
  //
  textSelectionTheme: TextSelectionThemeData(
      cursorColor: obsidian,
      selectionColor: obsidian.withValues(alpha: 200),
      selectionHandleColor: obsidian.withValues(alpha: 130)),

  useMaterial3: true,
);

//ThemeData
//
ThemeData themeDark = ThemeData.dark().copyWith(
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: largeSize,
          color: ghostWhite,
          fontFamily: 'Karla'),
      bodyMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: mediumSize,
          color: ghostWhite,
          fontFamily: 'Karla'),
      bodySmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: smallSize,
          color: ghostWhite,
          fontFamily: 'Karla'),
      labelLarge: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: largeSize,
          color: ghostWhite,
          fontFamily: 'Karla'),
      labelMedium: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: mediumSize,
          color: ghostWhite,
          fontFamily: 'Karla'),
      labelSmall: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: smallSize,
          color: ghostWhite,
          fontFamily: 'Karla'),
    ),
    //SnackBarTheme
    //
    snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),

    //ScrollbarTheme
    //
    scrollbarTheme: const ScrollbarThemeData(
      trackVisibility: WidgetStatePropertyAll(true),
      interactive: true,
      thickness: WidgetStatePropertyAll(8),
      thumbVisibility: WidgetStatePropertyAll(true),
    ),

    //InputDecorationTheme
    //
    inputDecorationTheme: const InputDecorationTheme(
      focusColor: ghostWhite,
      labelStyle: TextStyle(color: ghostWhite),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ghostWhite),
      ),
    ),

    //TextSelectionTheme
    //
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: ghostWhite,
        selectionColor: ghostWhite.withValues(alpha: 200),
        selectionHandleColor: ghostWhite.withValues(alpha: 130)),

    //Card
    //
    cardColor: primary.withValues(alpha: 100),

    //NavigationBarThemeData
    //
    navigationBarTheme: const NavigationBarThemeData(
        labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: smallSize))),

    //Color Scheme
    //
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      primary: primary,
      secondary: secondary,
    ));
