import 'package:flutter/material.dart';

ThemeData buildTheme() {
  const brandGreen = Color(0xFF19C463);
  const bg = Color(0xFFF7F9FB);

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: brandGreen),
    scaffoldBackgroundColor: bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.black.withOpacity(.45)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: brandGreen,
      secondarySelectedColor: brandGreen,
      labelStyle: TextStyle(color: Colors.black),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: StadiumBorder(),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
  );
}