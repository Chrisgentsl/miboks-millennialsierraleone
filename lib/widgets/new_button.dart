import 'package:flutter/material.dart';

class NewButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Size? size; // Added size parameter

  const NewButton({
    super.key,
    required this.onPressed,
    this.size, // Optional size parameter
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color(0xFF6621DC), // Updated to use the new color
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        minimumSize: const Size(132, 69), // Updated button size
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
      ),
      icon: const Icon(
        Icons.add, // Plus icon on the left
        color: Colors.white,
        size: 15.52, // Updated icon size
      ),
      label: const Text(
        'New', // Text on the right
        style: TextStyle(
          color: Colors.white,
          fontSize: 25.0, // Updated font size
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Updated NewButton2 to navigate to the 'Create New' tab in the InvoiceScreen
class NewButton2 extends StatelessWidget {
  final VoidCallback onPressed;
  final TabController tabController;

  const NewButton2({
    super.key,
    required this.onPressed,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        tabController.animateTo(1); // Navigate to the 'Create New' tab
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6621DC), // Same color as NewButton
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        minimumSize: const Size(376, 42), // Set height to 42 and width to 376
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
        alignment: Alignment.centerLeft, // Align text to the left
      ),
      icon: const Icon(
        Icons.add, // Plus icon on the left
        color: Colors.white,
        size: 15.52, // Same icon size as NewButton
      ),
      label: const Text(
        'New Invoice', // Updated text to 'New Invoice'
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0, // Decreased font size to 16
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
