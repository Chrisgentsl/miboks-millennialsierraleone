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
          // Search input widget
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search inventory items...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF6621DC)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color(0xFF6621DC)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  // Search functionality will go here
                },
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