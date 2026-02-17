import 'package:flutter/material.dart';
import '../../domain/category.dart';

class CategoryTile extends StatelessWidget {
  final CategoryItem item;
  final VoidCallback onTap;

  const CategoryTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(item.imageUrl, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFFEFEFEF))),
          // Degradado verde tipo mockup
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0x9919C463), // verde con opacidad
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.55],
                ),
              ),
            ),
          ),
          // Nombre
          Positioned(
            left: 12,
            bottom: 12,
            child: Text(
              item.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
              ),
            ),
          ),
          // Tocar
          Material(
            color: Colors.transparent,
            child: InkWell(onTap: onTap),
          ),
        ],
      ),
    );
  }
}