import 'package:flutter/material.dart';

class ProductItemWidget extends StatelessWidget {
  final String name;
  final String category;
  final int quantity;
  final bool showDetailedView;

  // Thresholds for stock status
  static const int _criticalThreshold = 10;
  static const int _lowThreshold = 20;

  const ProductItemWidget({
    super.key,
    required this.name,
    required this.category,
    required this.quantity,
    this.showDetailedView = true,
  });

  // Determine stock status based on quantity
  String get stockStatus {
    if (quantity <= _criticalThreshold) return 'Low';
    if (quantity <= _lowThreshold) return 'Critical';
    return 'Good';
  }

  // Get color based on stock status
  Color get statusColor {
    switch (stockStatus) {
      case 'Low':
        return Colors.red;
      case 'Critical':
        return Colors.amber;
      case 'Good':
        return Colors.green.shade300; // Mint green
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: showDetailedView ? _buildDetailedView() : _buildCompactView(),
      ),
    );
  }

  // Detailed view showing all product information
  Widget _buildDetailedView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildStatusIndicator(),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Category: $category',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Quantity: $quantity',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  // Compact view showing minimal information
  Widget _buildCompactView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                category,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _buildStatusIndicator(),
      ],
    );
  }

  // Status indicator showing color and text
  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            stockStatus,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}