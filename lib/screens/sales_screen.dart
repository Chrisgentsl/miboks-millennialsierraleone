import 'package:flutter/material.dart';
import '../logo_widget.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: LogoWidget(
            size: 40, // Adjust size for the top-left corner
            animate: false, // Disable animation for static placement
          ),
        ),
        title: const Text('Sales'),
        actions: [],
      ),
      body: Center(
        child: Text(
          'This is the Sales Screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}