import 'package:flutter/material.dart';
import '../../domain/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCard({super.key, required this.product, required this.onAdd});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scale = Tween(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _tapAdd() async {
    await _ctrl.forward();
    await _ctrl.reverse();
    widget.onAdd();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/transparent.png', // coloca un 1x1 transparente si deseas
                    image: p.imageUrl,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFEFEFEF),
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Categoría
              Text(
                p.category.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 0.6,
                  color: Colors.black.withOpacity(.55),
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              // Título
              Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),

              const SizedBox(height: 4),

              // Precio
              Row(
                children: [
                  Text(
                    '\$${p.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Color(0xFF19C463), fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  Text(' /${p.unit}', style: TextStyle(color: Colors.black.withOpacity(.45))),
                ],
              ),

              const Spacer(),

              // Seller + rating
              Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.orange.shade100,
                    child: const Icon(Icons.person, size: 14, color: Colors.orange),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${p.seller} • ⭐ ${p.rating.toStringAsFixed(1)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black.withOpacity(.65), fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Botón +
                  ScaleTransition(
                    scale: _scale,
                    child: InkResponse(
                      onTap: _tapAdd,
                      radius: 24,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF19C463),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}