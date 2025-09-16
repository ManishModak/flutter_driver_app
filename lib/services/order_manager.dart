import '../models/order.dart';

/// OrderManager handles the state and persistence of orders.
/// It maintains assigned orders and completed order history.
class OrderManager {
  // Singleton pattern for global state management
  static final OrderManager _instance = OrderManager._internal();
  factory OrderManager() => _instance;
  OrderManager._internal();

  // In-memory storage for orders (in production, this would be persisted)
  final List<Order> _assignedOrders = [];
  final List<Order> _completedOrders = [];

  /// Get all currently assigned orders
  List<Order> getAssignedOrders() {
    if (_assignedOrders.isEmpty) {
      // Initialize with demo order on first access
      _addDefaultDemoOrder();
    }
    return List.unmodifiable(_assignedOrders);
  }

  /// Get all completed orders (order history)
  List<Order> getCompletedOrders() {
    return List.unmodifiable(_completedOrders);
  }

  /// Mark an order as completed and move it to history
  void completeOrder(String orderId) {
    final orderIndex = _assignedOrders.indexWhere(
      (order) => order.id == orderId,
    );
    if (orderIndex != -1) {
      final completedOrder = _assignedOrders.removeAt(orderIndex);
      // Update the order with completion timestamp
      final updatedOrder = Order(
        id: completedOrder.id,
        restaurantName: completedOrder.restaurantName,
        restaurantLat: completedOrder.restaurantLat,
        restaurantLng: completedOrder.restaurantLng,
        customerName: completedOrder.customerName,
        customerLat: completedOrder.customerLat,
        customerLng: completedOrder.customerLng,
        orderAmount: completedOrder.orderAmount,
        completedAt: DateTime.now(),
      );
      _completedOrders.insert(
        0,
        updatedOrder,
      ); // Add to beginning for recent-first order
      print('📦 Order ${orderId} completed and moved to history');
    }
  }

  /// Add a new assigned order (for demo purposes)
  void addDemoOrder() {
    final newOrder = _generateDemoOrder();
    _assignedOrders.add(newOrder);
    print('📦 New demo order added: ${newOrder.id}');
  }

  /// Initialize with default demo order
  void _addDefaultDemoOrder() {
    final demoOrder = Order(
      id: 'ORD-12345',
      restaurantName: 'Gourmet Burger Kitchen',
      restaurantLat: 37.190955,
      restaurantLng: -121.749845,
      customerName: 'Jane Doe',
      customerLat: 37.195985,
      customerLng: -121.743793,
      orderAmount: 35.75,
    );
    _assignedOrders.add(demoOrder);
  }

  /// Generate a new demo order with randomized data
  Order _generateDemoOrder() {
    final restaurants = [
      {'name': 'Pizza Palace', 'lat': 37.189234, 'lng': -121.751234},
      {'name': 'Taco Fiesta', 'lat': 37.192567, 'lng': -121.745678},
      {'name': 'Sushi Express', 'lat': 37.187890, 'lng': -121.753456},
      {'name': 'Burger Bliss', 'lat': 37.194321, 'lng': -121.748901},
      {'name': 'Indian Spice', 'lat': 37.191234, 'lng': -121.752345},
    ];

    final customers = [
      {'name': 'John Smith', 'lat': 37.196789, 'lng': -121.744567},
      {'name': 'Emily Johnson', 'lat': 37.188456, 'lng': -121.754321},
      {'name': 'Mike Chen', 'lat': 37.193456, 'lng': -121.747890},
      {'name': 'Sarah Wilson', 'lat': 37.189789, 'lng': -121.751234},
      {'name': 'David Brown', 'lat': 37.195123, 'lng': -121.746789},
    ];

    final restaurant =
        restaurants[DateTime.now().millisecond % restaurants.length];
    final customer = customers[DateTime.now().microsecond % customers.length];

    // Generate random order ID
    final orderId =
        'ORD-${(DateTime.now().millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}';

    // Generate random order amount between $15-$75
    final amount = 15.0 + (DateTime.now().millisecond % 60);

    return Order(
      id: orderId,
      restaurantName: restaurant['name'] as String,
      restaurantLat: restaurant['lat'] as double,
      restaurantLng: restaurant['lng'] as double,
      customerName: customer['name'] as String,
      customerLat: customer['lat'] as double,
      customerLng: customer['lng'] as double,
      orderAmount: double.parse(amount.toStringAsFixed(2)),
    );
  }

  /// Clear all orders (for testing purposes)
  void clearAllOrders() {
    _assignedOrders.clear();
    _completedOrders.clear();
    print('📦 All orders cleared');
  }

  /// Add multiple demo completed orders for testing order history
  void addDemoCompletedOrders() {
    final demoCompletedOrders = [
      Order(
        id: 'ORD-11111',
        restaurantName: 'Thai Garden',
        restaurantLat: 37.188234,
        restaurantLng: -121.752234,
        customerName: 'Alex Johnson',
        customerLat: 37.194567,
        customerLng: -121.746789,
        orderAmount: 42.50,
        completedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Order(
        id: 'ORD-22222',
        restaurantName: 'Coffee Corner',
        restaurantLat: 37.191456,
        restaurantLng: -121.750123,
        customerName: 'Lisa Davis',
        customerLat: 37.187890,
        customerLng: -121.753456,
        orderAmount: 18.25,
        completedAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      Order(
        id: 'ORD-33333',
        restaurantName: 'Mexican Grill',
        restaurantLat: 37.193789,
        restaurantLng: -121.748456,
        customerName: 'Robert Wilson',
        customerLat: 37.189123,
        customerLng: -121.754789,
        orderAmount: 28.90,
        completedAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];

    _completedOrders.addAll(demoCompletedOrders);
    print('📦 Added ${demoCompletedOrders.length} demo completed orders');
  }

  /// Get order statistics
  Map<String, dynamic> getOrderStats() {
    final totalCompleted = _completedOrders.length;
    final totalAssigned = _assignedOrders.length;
    final totalEarnings = _completedOrders.fold<double>(
      0.0,
      (sum, order) => sum + order.orderAmount,
    );

    return {
      'totalCompleted': totalCompleted,
      'totalAssigned': totalAssigned,
      'totalEarnings': totalEarnings,
      'averageOrderValue': totalCompleted > 0
          ? totalEarnings / totalCompleted
          : 0.0,
    };
  }
}
