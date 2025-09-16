import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/order.dart';
import '../services/location_service.dart';
import '../services/order_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import '../util/order_status_enum.dart';

class AssignedOrderScreen extends StatefulWidget {
  final Order order;
  
  const AssignedOrderScreen({super.key, required this.order});

  @override
  State<AssignedOrderScreen> createState() => _AssignedOrderScreenState();
}

class _AssignedOrderScreenState extends State<AssignedOrderScreen> {
  final LocationService _locationService = LocationService();
  final OrderManager _orderManager = OrderManager();
  
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;
  OrderStatus _orderStatus = OrderStatus.Assigned;

  // Getter for the assigned order from widget
  Order get assignedOrder => widget.order;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    // Listen to the stream of position updates from our service
    _positionStreamSubscription = _locationService.getPositionStream().listen((
      Position position,
    ) {
      // Update the UI with the new position
      setState(() {
        _currentPosition = position;
      });

      print(
        '📍 Location Update: Lat: ${position.latitude}, Lng: ${position.longitude}',
      );
    });
  }

  void _launchMaps(double lat, double lng) async {
    // Construct the Google Maps URL.
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $googleMapsUrl';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open maps: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${assignedOrder.id}'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simple Status Indicator
            _buildSimpleStatusIndicator(),

            const SizedBox(height: 16),

            // Section for Restaurant Details
            _buildSimpleLocationCard(
              title: 'Restaurant',
              name: assignedOrder.restaurantName,
              lat: assignedOrder.restaurantLat,
              lng: assignedOrder.restaurantLng,
              icon: Icons.restaurant,
            ),
            const SizedBox(height: 16),

            // Section for Customer Details
            _buildSimpleLocationCard(
              title: 'Customer',
              name: assignedOrder.customerName,
              lat: assignedOrder.customerLat,
              lng: assignedOrder.customerLng,
              icon: Icons.person,
            ),
            const SizedBox(height: 16),

            // Order Amount
            _buildSimpleOrderAmount(),

            const SizedBox(height: 16),

            // Driver Location
            _buildSimpleDriverLocation(),

            const SizedBox(height: 20),

            // Action Widget
            _buildSimpleActionWidget(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Simple status indicator
  Widget _buildSimpleStatusIndicator() {
    String statusText = _getStatusText();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.teal),
            const SizedBox(width: 8),
            Text(
              'Status: $statusText',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText() {
    switch (_orderStatus) {
      case OrderStatus.Assigned:
        return 'Order Assigned';
      case OrderStatus.TripStarted:
        return 'En Route to Restaurant';
      case OrderStatus.AtRestaurant:
        return 'At Restaurant';
      case OrderStatus.PickedUp:
        return 'En Route to Customer';
      case OrderStatus.AtCustomer:
        return 'At Customer';
      case OrderStatus.Delivered:
        return 'Delivered';
    }
  }

  // Simple location card
  Widget _buildSimpleLocationCard({
    required String title,
    required String name,
    required double lat,
    required double lng,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.teal, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _launchMaps(lat, lng),
                  icon: const Icon(Icons.navigation, size: 18),
                  label: const Text('Navigate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'Location: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleOrderAmount() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.receipt, color: Colors.green, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Order Amount:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              '\$${assignedOrder.orderAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleDriverLocation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.my_location, color: Colors.blue, size: 24),
                SizedBox(width: 8),
                Text(
                  'My Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _currentPosition != null
                  ? '${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}'
                  : 'Getting location...',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters >= 1000) {
      final double distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(1)} km';
    } else {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    }
  }

  // Simple action widget with all geofencing functionality preserved
  Widget _buildSimpleActionWidget() {
    switch (_orderStatus) {
      case OrderStatus.Assigned:
        return _buildSimpleButton('Start Trip', Colors.teal, () {
          setState(() => _orderStatus = OrderStatus.TripStarted);
        });

      case OrderStatus.TripStarted:
        double distanceToRestaurant = double.infinity;
        if (_currentPosition != null) {
          distanceToRestaurant = _locationService.getDistance(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            assignedOrder.restaurantLat,
            assignedOrder.restaurantLng,
          );
        }
        bool canArrive = distanceToRestaurant <= 50;

        // Debug logging
        print('--- GEOFENCE CHECK (Restaurant) ---');
        print('Distance: $distanceToRestaurant meters, Can Arrive: $canArrive');

        return Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Distance to Restaurant: ${_formatDistance(distanceToRestaurant)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: canArrive ? Colors.green : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      canArrive
                          ? 'You can proceed!'
                          : 'Move closer to continue',
                      style: TextStyle(
                        fontSize: 14,
                        color: canArrive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildSimpleButton(
              'Arrived at Restaurant',
              canArrive ? Colors.teal : Colors.grey,
              canArrive
                  ? () {
                      setState(() => _orderStatus = OrderStatus.AtRestaurant);
                    }
                  : null,
            ),
          ],
        );

      case OrderStatus.AtRestaurant:
        return _buildSimpleButton('Picked Up Order', Colors.orange, () {
          setState(() => _orderStatus = OrderStatus.PickedUp);
        });

      case OrderStatus.PickedUp:
        double distanceToCustomer = double.infinity;
        if (_currentPosition != null) {
          distanceToCustomer = _locationService.getDistance(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            assignedOrder.customerLat,
            assignedOrder.customerLng,
          );
        }
        bool canDeliver = distanceToCustomer <= 50;

        // Debug logging
        print('--- GEOFENCE CHECK (Customer) ---');
        print('Distance: $distanceToCustomer meters, Can Deliver: $canDeliver');

        return Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Distance to Customer: ${_formatDistance(distanceToCustomer)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: canDeliver ? Colors.green : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      canDeliver
                          ? 'You can proceed!'
                          : 'Move closer to continue',
                      style: TextStyle(
                        fontSize: 14,
                        color: canDeliver ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildSimpleButton(
              'Arrived at Customer',
              canDeliver ? Colors.teal : Colors.grey,
              canDeliver
                  ? () {
                      setState(() => _orderStatus = OrderStatus.AtCustomer);
                    }
                  : null,
            ),
          ],
        );

      case OrderStatus.AtCustomer:
        return _buildSimpleButton('Complete Delivery', Colors.green, () {
          setState(() => _orderStatus = OrderStatus.Delivered);
          // Complete the order in OrderManager
          _orderManager.completeOrder(assignedOrder.id);
        });

      case OrderStatus.Delivered:
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.check_circle, size: 48, color: Colors.green),
                const SizedBox(height: 16),
                const Text(
                  'Order Completed! 🎉',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Great job! The delivery has been completed successfully.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      // Return to home screen with completion result
                      Navigator.of(context).pop('completed');
                    },
                    child: const Text(
                      'Return to Dashboard',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildSimpleButton(String text, Color color, VoidCallback? onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
