import '../../domain/product.dart';

abstract class CartEvent {}

class CartItemAdded extends CartEvent {
  final Product product;
  CartItemAdded(this.product);
}

class CartItemRemoved extends CartEvent {
  final Product product;
  CartItemRemoved(this.product);
}

class CartItemIncreased extends CartEvent {
  final Product product;
  CartItemIncreased(this.product);
}

class CartItemDecreased extends CartEvent {
  final Product product;
  CartItemDecreased(this.product);
}

class CartCleared extends CartEvent {}
