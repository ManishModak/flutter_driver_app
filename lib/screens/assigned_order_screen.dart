// lib/screens/assigned_order_screen.dart
import 'package:flutter/material.dart';

class AssignedOrderScreen extends StatefulWidget {
  const AssignedOrderScreen({super.key});

  @override
  State<AssignedOrderScreen> createState() => _AssignedOrderScreenState();
}

class _AssignedOrderScreenState extends State<AssignedOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assigned Order')),
      body: const Center(child: Text('Order details will appear here.')),
    );
  }
}
