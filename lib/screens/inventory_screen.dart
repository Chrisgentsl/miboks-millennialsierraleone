import 'package:flutter/material.dart';
import '../logo_widget.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: LogoWidget(
            size: 40, // Adjust size for the top-left corner
            animate: true, // Disable animation for static placement
          ),
        ),
        title: const Text(
          'Inventory',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Made the text bold
          ),
        ),
        actions: [],
      ),
      body: Column(
        children: [
          Container(
            height: 1.0,
            color: Colors.black, // Black horizontal line
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Manage your Inventory Items',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey, // Grey color for the text
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  // Add item functionality will go here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6621DC), // Purple background color
                  foregroundColor: Colors.white, // White text color
                ),
                child: const Text('Add Item'),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'This is the Inventory Screen',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}