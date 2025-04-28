import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../screens/invoice_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/inventory_screen.dart';
import '../screens/sales_screen.dart';
import '../screens/suppliers_screen.dart';
import '../screens/settings_screen.dart';

class BottomNavbarWidget extends StatefulWidget {
  const BottomNavbarWidget({super.key});

  @override
  _BottomNavbarWidgetState createState() => _BottomNavbarWidgetState();
}

class _BottomNavbarWidgetState extends State<BottomNavbarWidget> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const InvoiceScreen(),
    const InventoryScreen(),
    const SalesScreen(),
    const SuppliersScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent, // Transparent to show curve effect
        color: const Color(0xFF6621DC),
        buttonBackgroundColor: const Color(0xFF6621DC),
        animationDuration: const Duration(milliseconds: 300),
        items: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dashboard, color: _selectedIndex == 0 ? Colors.white : Colors.white),
              if (_selectedIndex == 0)
                const Text('Dashboard', style: TextStyle(color: Colors.white)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt, color: _selectedIndex == 1 ? Colors.white : Colors.white),
              if (_selectedIndex == 1)
                const Text('Invoice', style: TextStyle(color: Colors.white)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory, color: _selectedIndex == 2 ? Colors.white : Colors.white),
              if (_selectedIndex == 2)
                const Text('Inventory', style: TextStyle(color: Colors.white)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart, color: _selectedIndex == 3 ? Colors.white : Colors.white),
              if (_selectedIndex == 3)
                const Text('Sales', style: TextStyle(color: Colors.white)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people, color: _selectedIndex == 4 ? Colors.white : Colors.white),
              if (_selectedIndex == 4)
                const Text('Suppliers', style: TextStyle(color: Colors.white)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.settings, color: _selectedIndex == 5 ? Colors.white : Colors.white),
              if (_selectedIndex == 5)
                const Text('Settings', style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
