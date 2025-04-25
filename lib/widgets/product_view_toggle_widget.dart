import 'package:flutter/material.dart';

class ProductViewToggleWidget extends StatefulWidget {
  final Function(bool) onViewChanged;
  final bool initialShowAllProducts;

  const ProductViewToggleWidget({
    super.key,
    required this.onViewChanged,
    this.initialShowAllProducts = false,
  });

  @override
  State<ProductViewToggleWidget> createState() => _ProductViewToggleWidgetState();
}

class _ProductViewToggleWidgetState extends State<ProductViewToggleWidget> {
  late bool _showAllProducts;

  @override
  void initState() {
    super.initState();
    _showAllProducts = widget.initialShowAllProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Individual Products View Button
            _buildViewButton(
              icon: Icons.view_module,
              label: 'Individual',
              isSelected: !_showAllProducts,
              onTap: () {
                if (_showAllProducts) {
                  setState(() {
                    _showAllProducts = false;
                  });
                  widget.onViewChanged(false);
                }
              },
            ),
            // All Products View Button
            _buildViewButton(
              icon: Icons.view_list,
              label: 'All Products',
              isSelected: _showAllProducts,
              onTap: () {
                if (!_showAllProducts) {
                  setState(() {
                    _showAllProducts = true;
                  });
                  widget.onViewChanged(true);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6621DC).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(6.0),
          border: isSelected
              ? Border.all(color: const Color(0xFF6621DC))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF6621DC) : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 4.0),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF6621DC) : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}