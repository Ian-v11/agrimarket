import '../../domain/cart_item.dart';

class CartState {
  final List<CartItem> items;
  final int bump; // se incrementa al agregar para animar el icono

  const CartState({required this.items, required this.bump});

  factory CartState.initial() => const CartState(items: [], bump: 0);

  int get totalCount => items.fold(0, (a, b) => a + b.qty);
  double get totalPrice => items.fold(0.0, (a, b) => a + b.subtotal);
}