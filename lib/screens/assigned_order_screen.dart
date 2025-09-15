import 'package:flutter/material.dart';
import '../models/order.dart';

class AssignedOrderScreen extends StatefulWidget {
  const AssignedOrderScreen({super.key});

  @override
  State<AssignedOrderScreen> createState() => _AssignedOrderScreenState();
}

class _AssignedOrderScreenState extends State<AssignedOrderScreen> {
  // Creating a hardcoded "dummy" order for display.
  // We are using realistic coordinates for testing navigation later.
  final Order assignedOrder = Order(
    id: 'ORD-12345',
    restaurantName: 'Gourmet Burger Kitchen',
    // Coordinates for the Googleplex in Mountain View, CA
    restaurantLat: 37.4219999,
    restaurantLng: -122.0840575,
    customerName: 'Jane Doe',
    // Coordinates for Stanford University
    customerLat: 37.4274745,
    customerLng: -122.1702937,
    orderAmount: 35.75,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${assignedOrder.id}'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section for Restaurant Details
            _buildLocationCard(
              title: 'Restaurant',
              name: assignedOrder.restaurantName,
              lat: assignedOrder.restaurantLat,
              lng: assignedOrder.restaurantLng,
            ),
            const SizedBox(height: 16),

            // Section for Customer Details
            _buildLocationCard(
              title: 'Customer',
              name: assignedOrder.customerName,
              lat: assignedOrder.customerLat,
              lng: assignedOrder.customerLng,
            ),
            const SizedBox(height: 24),

            // Section for Order Amount
            Center(
              child: Text(
                'Order Amount: \$${assignedOrder.orderAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  // A reusable helper widget to display location info in a Card.
  Widget _buildLocationCard({
    required String title,
    required String name,
    required double lat,
    required double lng,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(
              'Coordinates: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
