import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: Center(
        child: Text(
          'This is the Inventory Screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}