// lib/models/order.dart
class Order {
  final String id;
  final String restaurantName;
  final double restaurantLat;
  final double restaurantLng;
  final String customerName;
  final double customerLat;
  final double customerLng;
  final double orderAmount;
  final DateTime? completedAt;

  Order({
    required this.id,
    required this.restaurantName,
    required this.restaurantLat,
    required this.restaurantLng,
    required this.customerName,
    required this.customerLat,
    required this.customerLng,
    required this.orderAmount,
    this.completedAt,
  });

  /// Helper method to check if order is completed
  bool get isCompleted => completedAt != null;

  /// Helper method to get formatted completion time
  String get formattedCompletionTime {
    if (completedAt == null) return 'Not completed';

    final now = DateTime.now();
    final difference = now.difference(completedAt!);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
