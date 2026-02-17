import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_event.dart';
import '../../bloc/cart/cart_state.dart';
import '../../bloc/catalog/catalog_bloc.dart';
import '../../bloc/catalog/catalog_event.dart';
import '../../bloc/catalog/catalog_state.dart';
import '../../domain/product.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final AnimationController _cartController;
  late final Animation<double> _cartScale;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _cartController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _cartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _cartController, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    _cartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = const ['Vegetales', 'Granos', 'Tubérculos', 'Frutas', 'Hortalizas'];
    final locations = const ['Bilwi', 'Matagalpa', 'Estelí', 'León', 'Granada', 'Chontales'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriMarket'),
        actions: [
          BlocListener<CartBloc, CartState>(
            listenWhen: (p, c) => c.bump != p.bump, // anima cuando se agrega
            listener: (_, __) => _cartController.forward(from: 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartPage()));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, cart) {
                    return ScaleTransition(
                      scale: _cartScale,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.shopping_cart_outlined, size: 28),
                          if (cart.totalCount > 0)
                            Positioned(
                              right: -6,
                              top: -6,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                transitionBuilder: (child, anim) =>
                                    ScaleTransition(scale: anim, child: child),
                                child: Container(
                                  key: ValueKey(cart.totalCount),
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF19C463),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    cart.totalCount.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CatalogBloc, CatalogState>(
          builder: (context, state) {
            return Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _controller,
                    onChanged: (q) =>
                        context.read<CatalogBloc>().add(CatalogQueryChanged(q)),
                    decoration: InputDecoration(
                      hintText: 'Buscar productos',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: state.query.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          context.read<CatalogBloc>().add(CatalogQueryChanged(''));
                        },
                      )
                          : null,
                    ),
                  ),
                ),

                // Filtros
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      _FilterChipPopup<String?>(
                        label: 'Categoria',
                        valueText: state.category ?? 'Todo',
                        icon: Icons.category_outlined,
                        options: [null, ...categories],
                        itemText: (v) => v ?? 'Todo',
                        onSelected: (v) => context.read<CatalogBloc>().add(CatalogCategoryChanged(v)),
                      ),
                      const SizedBox(width: 8),
                      _FilterChipPopup<String?>(
                        label: 'Localidad',
                        valueText: state.location ?? 'Todo',
                        icon: Icons.place_outlined,
                        options: [null, ...locations],
                        itemText: (v) => v ?? 'Todo',
                        onSelected: (v) => context.read<CatalogBloc>().add(CatalogLocationChanged(v)),
                      ),
                      const SizedBox(width: 8),
                      _FilterChipPopup<PriceSort>(
                        label: 'Precios',
                        valueText: switch (state.sort) {
                          PriceSort.lowToHigh => 'Bajo→Alto',
                          PriceSort.highToLow => 'Alto→Bajo',
                          PriceSort.none => 'Cualquiera'
                        },
                        icon: Icons.attach_money,
                        options: const [PriceSort.none, PriceSort.lowToHigh, PriceSort.highToLow],
                        itemText: (v) => switch (v) {
                          PriceSort.none => 'Cualquiera',
                          PriceSort.lowToHigh => 'Bajo a Alto',
                          PriceSort.highToLow => 'Alto a Bajo  ',
                        },
                        onSelected: (v) => context.read<CatalogBloc>().add(CatalogPriceSortChanged(v)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Grid de productos
                Expanded(
                  child: state.loading
                      ? const Center(child: CircularProgressIndicator())
                      : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      itemCount: state.visible.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: .72,
                      ),
                      itemBuilder: (context, index) {
                        final p = state.visible[index];
                        return ProductCard(
                          product: p,
                          onAdd: () => context.read<CartBloc>().add(CartItemAdded(p)),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      // Bottom bar tipo mockup (no funcional, decorativo)
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.sell_outlined), label: 'Ventas'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Orden'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF19C463),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartPage())),
        child: const Icon(Icons.add_shopping_cart, color: Colors.white),
      ),
    );
  }
}

class _FilterChipPopup<T> extends StatelessWidget {
  final String label;
  final String valueText;
  final IconData icon;
  final List<T> options;
  final String Function(T) itemText;
  final void Function(T) onSelected;

  const _FilterChipPopup({
    required this.label,
    required this.valueText,
    required this.icon,
    required this.options,
    required this.itemText,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onSelected,
      position: PopupMenuPosition.under,
      itemBuilder: (context) => options
          .map((o) => PopupMenuItem<T>(
        value: o,
        child: Text(itemText(o)),
      ))
          .toList(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black.withOpacity(.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            Text(valueText, style: TextStyle(color: Colors.black.withOpacity(.55))),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}