import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'presentation/screens/catalog_page.dart';

class AgriMarketApp extends StatelessWidget {
  const AgriMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriMarket',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const CatalogPage(),
    );
  }
}
