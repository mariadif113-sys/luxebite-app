import 'package:flutter_riverpod/flutter_riverpod.dart';

enum OrderStatus { pending, preparing, ready, delivered }

class AdminOrder {
  final String id;
  final String customerName;
  final List<String> items;
  final double totalPrice;
  final OrderStatus status;
  final DateTime timestamp;

  AdminOrder({
    required this.id,
    required this.customerName,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.timestamp,
  });

  AdminOrder copyWith({OrderStatus? status}) {
    return AdminOrder(
      id: id,
      customerName: customerName,
      items: items,
      totalPrice: totalPrice,
      status: status ?? this.status,
      timestamp: timestamp,
    );
  }
}

final adminOrdersProvider = StateNotifierProvider<AdminOrdersNotifier, List<AdminOrder>>((ref) {
  return AdminOrdersNotifier();
});

class AdminOrdersNotifier extends StateNotifier<List<AdminOrder>> {
  AdminOrdersNotifier() : super([]) {
    _loadInitialOrders();
  }

  void _loadInitialOrders() {
    state = [
      AdminOrder(
        id: '#LX-9012',
        customerName: 'Ahmed Benali',
        items: ['Truffle Ribeye Steak', 'Azure Berry Mocktail'],
        totalPrice: 5180.0,
        status: OrderStatus.pending,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      AdminOrder(
        id: '#LX-9013',
        customerName: 'Sarah Mansouri',
        items: ['Wagyu Smash Burger', 'Gold Leaf Cappuccino'],
        totalPrice: 2550.0,
        status: OrderStatus.preparing,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      AdminOrder(
        id: '#LX-9014',
        customerName: 'Karim Zidani',
        items: ['Premium Tacos', 'Mixed Grill Platter'],
        totalPrice: 4450.0,
        status: OrderStatus.ready,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
    ];
  }

  void updateOrderStatus(String id, OrderStatus newStatus) {
    state = [
      for (final order in state)
        if (order.id == id) order.copyWith(status: newStatus) else order,
    ];
  }
}
