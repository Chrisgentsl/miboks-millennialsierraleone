import 'package:flutter/material.dart';

class SupplierScreen extends StatelessWidget {
  const SupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplier Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Supplier Screen!'),
      ),
    );
  }
}