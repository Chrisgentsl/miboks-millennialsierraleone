import 'package:flutter/material.dart';

class WarningAlertIcon extends StatelessWidget {
  final String warningCount;

  const WarningAlertIcon({
    super.key,
    required this.warningCount,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8.0,
      right: 8.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              warningCount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4.0), // Spacing between figure and icon
          const Icon(
            Icons.warning,
            color: Colors.red, // Red warning icon
            size: 24.0,
          ),
        ],
      ),
    );
  }
}