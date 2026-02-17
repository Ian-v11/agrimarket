import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/cart_item.dart';
import '../../domain/product.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.initial()) {
    on<CartItemAdded>(_onAdd);
    on<CartItemRemoved>(_onRemove);
    on<CartItemIncreased>(_onIncrease);
    on<CartItemDecreased>(_onDecrease);
    on<CartCleared>(_onClear);
  }

  void _onAdd(CartItemAdded e, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((it) => it.product.id == e.product.id);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(qty: items[idx].qty + 1);
    } else {
      items.add(CartItem(product: e.product, qty: 1));
    }
    emit(CartState(items: items, bump: state.bump + 1));
  }

  void _onRemove(CartItemRemoved e, Emitter<CartState> emit) {
    final items = state.items.where((it) => it.product.id != e.product.id).toList();
    emit(CartState(items: items, bump: state.bump));
  }

  void _onIncrease(CartItemIncreased e, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((it) => it.product.id == e.product.id);
    if (idx >= 0) items[idx] = items[idx].copyWith(qty: items[idx].qty + 1);
    emit(CartState(items: items, bump: state.bump));
  }

  void _onDecrease(CartItemDecreased e, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((it) => it.product.id == e.product.id);
    if (idx >= 0) {
      final next = items[idx].qty - 1;
      if (next <= 0) {
        items.removeAt(idx);
      } else {
        items[idx] = items[idx].copyWith(qty: next);
      }
    }
    emit(CartState(items: items, bump: state.bump));
  }

  void _onClear(CartCleared e, Emitter<CartState> emit) {
    emit(CartState(items: const [], bump: state.bump));
  }
}