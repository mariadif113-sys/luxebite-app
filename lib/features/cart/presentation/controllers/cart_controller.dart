import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/menu/domain/models/menu_models.dart';

class CartItem {
  final MenuItem menuItem;
  final int quantity;

  CartItem({required this.menuItem, required this.quantity});

  CartItem copyWith({int? quantity}) {
    return CartItem(menuItem: menuItem, quantity: quantity ?? this.quantity);
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(MenuItem item) {
    final existingIndex = state.indexWhere((element) => element.menuItem.id == item.id);
    if (existingIndex != -1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            state[i].copyWith(quantity: state[i].quantity + 1)
          else
            state[i]
      ];
    } else {
      state = [...state, CartItem(menuItem: item, quantity: 1)];
    }
  }

  void removeItem(String itemId) {
    state = state.where((element) => element.menuItem.id != itemId).toList();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
    } else {
      state = [
        for (final item in state)
          if (item.menuItem.id == itemId)
            item.copyWith(quantity: quantity)
          else
            item
      ];
    }
  }

  double get totalPrice {
    return state.fold(0, (total, current) => total + (current.menuItem.price * current.quantity));
  }

  int get totalItems {
    return state.fold(0, (total, current) => total + current.quantity);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
