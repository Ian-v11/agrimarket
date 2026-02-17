import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_event.dart';
import '../../bloc/cart/cart_state.dart';
import '../../domain/cart_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(
              child: Text('Tu carrito está vacío. Agrega productos desde la tienda.'),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final item = state.items[i];
                    return _CartItemTile(item: item);
                  },
                ),
              ),
              _CartSummary(total: state.totalPrice),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final p = item.product;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(.06)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(p.imageUrl, width: 72, height: 72, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('${p.category} • ${p.location}',
                    style: TextStyle(color: Colors.black.withOpacity(.55), fontSize: 12)),
                const SizedBox(height: 6),
                Text('\$${p.price.toStringAsFixed(2)} /${p.unit}',
                    style: const TextStyle(color: Color(0xFF19C463), fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              IconButton(
                onPressed: () =>
                    context.read<CartBloc>().add(CartItemDecreased(p)),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(item.qty.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              IconButton(
                onPressed: () =>
                    context.read<CartBloc>().add(CartItemIncreased(p)),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          IconButton(
            onPressed: () => context.read<CartBloc>().add(CartItemRemoved(p)),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final double total;
  const _CartSummary({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 8)],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  Text('\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF19C463),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Checkout no implementado (demo)')),
                );
              },
              icon: const Icon(Icons.lock_outline),
              label: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}