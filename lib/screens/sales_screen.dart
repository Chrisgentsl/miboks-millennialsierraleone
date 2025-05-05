import 'package:flutter/material.dart';
import '../logo_widget.dart';
import '../widgets/sales_form_widget.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  Widget _buildAddItemBubble() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: SalesFormWidget(),
            );
          },
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF6621DC),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: LogoWidget(
            size: 40,
            animate: false,
          ),
        ),
        title: const Text('Sales'),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: _buildAddItemBubble(),
          ),
        ],
      ),
    );
  }
}