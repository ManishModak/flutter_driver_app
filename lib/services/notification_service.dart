import 'package:flutter/foundation.dart';
import '../models/order.dart';

/// NotificationService simulates push notifications for order events.
/// In a real app, this would integrate with Firebase Cloud Messaging or similar.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  /// Simulate notification for order completion
  void showOrderCompletedNotification(Order order) {
    final message =
        'Order #${order.id} completed successfully! 🎉\n'
        'Amount: \$${order.orderAmount.toStringAsFixed(2)}\n'
        'Customer: ${order.customerName}';

    _simulateNotification(
      title: 'Delivery Completed',
      body: message,
      type: 'order_completed',
    );
  }

  /// Simulate notification for new order assignment
  void showNewOrderAssignedNotification(Order order) {
    final message =
        'New order assigned: #${order.id}\n'
        'Restaurant: ${order.restaurantName}\n'
        'Amount: \$${order.orderAmount.toStringAsFixed(2)}';

    _simulateNotification(
      title: 'New Order Assigned',
      body: message,
      type: 'order_assigned',
    );
  }

  /// Simulate notification for proximity alerts
  void showProximityNotification(String location, double distance) {
    final message = 'You are ${distance.toInt()}m away from $location';

    _simulateNotification(
      title: 'Location Update',
      body: message,
      type: 'proximity',
    );
  }

  /// Simulate notification for delivery reminders
  void showDeliveryReminderNotification(Order order, String reminder) {
    final message =
        'Order #${order.id}: $reminder\n'
        'Customer: ${order.customerName}';

    _simulateNotification(
      title: 'Delivery Reminder',
      body: message,
      type: 'reminder',
    );
  }

  /// Core notification simulation method
  void _simulateNotification({
    required String title,
    required String body,
    required String type,
  }) {
    final timestamp = DateTime.now().toIso8601String();

    // In debug mode, print detailed notification info
    if (kDebugMode) {
      print('\n🔔 ==================== NOTIFICATION ====================');
      print('📱 Title: $title');
      print('📝 Body: $body');
      print('🏷️  Type: $type');
      print('⏰ Time: $timestamp');
      print('📤 Status: Notification sent successfully');
      print('🔔 ====================================================\n');
    }

    // Simulate server-side logging (in real app, this would send to analytics)
    _logNotificationToServer(title, body, type, timestamp);
  }

  /// Simulate sending notification data to server for analytics
  void _logNotificationToServer(
    String title,
    String body,
    String type,
    String timestamp,
  ) {
    if (kDebugMode) {
      print('📊 [SERVER LOG] Notification Analytics:');
      print('   - Driver ID: DRIVER_123 (simulated)');
      print('   - Notification Type: $type');
      print('   - Timestamp: $timestamp');
      print('   - Delivery Method: Push Notification');
      print('   - Status: Delivered\n');
    }
  }

  /// Simulate bulk notification for multiple orders (batch processing)
  void showBatchNotification(List<Order> orders, String message) {
    final orderIds = orders.map((o) => '#${o.id}').join(', ');
    final notification = 'Multiple orders update:\n$message\nOrders: $orderIds';

    _simulateNotification(
      title: 'Batch Update',
      body: notification,
      type: 'batch',
    );
  }

  /// Simulate emergency notification
  void showEmergencyNotification(String emergency) {
    _simulateNotification(
      title: '🚨 EMERGENCY ALERT',
      body: emergency,
      type: 'emergency',
    );
  }

  /// Test all notification types (for demo purposes)
  void testAllNotifications() {
    final testOrder = Order(
      id: 'TEST-001',
      restaurantName: 'Test Restaurant',
      restaurantLat: 37.0,
      restaurantLng: -121.0,
      customerName: 'Test Customer',
      customerLat: 37.1,
      customerLng: -121.1,
      orderAmount: 25.50,
    );

    if (kDebugMode) {
      print('\n🧪 TESTING ALL NOTIFICATION TYPES...\n');
    }

    // Test each notification type with delays
    Future.delayed(const Duration(seconds: 1), () {
      showNewOrderAssignedNotification(testOrder);
    });

    Future.delayed(const Duration(seconds: 2), () {
      showProximityNotification('Test Restaurant', 75);
    });

    Future.delayed(const Duration(seconds: 3), () {
      showDeliveryReminderNotification(
        testOrder,
        'Don\'t forget to collect payment',
      );
    });

    Future.delayed(const Duration(seconds: 4), () {
      showOrderCompletedNotification(testOrder);
    });

    Future.delayed(const Duration(seconds: 5), () {
      showBatchNotification([testOrder], 'Daily summary: 1 order completed');
    });
  }
}
