import 'package:flutter/material.dart';
import '../logo_widget.dart';
import '../widgets/new_button.dart';
import '../widgets/invoice_form_widget.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          'Invoice',
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
                'Manage your Invoices and Receipts',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey, // Grey color for the text
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: NewButton2(
                onPressed: () {
                  print('New Button 2 pressed');
                },
                tabController: _tabController, // Passed the TabController
              ),
            ),
          ),
          Expanded(
            child: InvoiceTabs(tabController: _tabController),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemBubble() {
    return GestureDetector(
      onTap: () => _showAddProductModal(),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF6621DC), // Updated to primary color
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showAddProductModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add Product',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Product Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Add product logic here
                      Navigator.pop(context);
                    },
                    child: const Text('Add Product'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Rendered the InvoiceFormWidget in the 'Create New' tab and ensured it fits well
class InvoiceTabs extends StatefulWidget {
  final TabController tabController;

  const InvoiceTabs({super.key, required this.tabController});

  @override
  _InvoiceTabsState createState() => _InvoiceTabsState();
}

class _InvoiceTabsState extends State<InvoiceTabs> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: widget.tabController,
          indicatorColor: const Color(0xFF6621DC), // Active session color
          labelColor: const Color(0xFF6621DC),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'All Invoices'),
            Tab(text: 'Create New'),
          ],
        ),
        const Divider(
          // Horizontal line under the tabs
          color: Colors.black,
          height: 1,
        ),
        Expanded(
          child: TabBarView(
            controller: widget.tabController,
            children: [
              Center(
                  child: Text(
                      'All Invoices Content')), // Placeholder for All Invoices
              SingleChildScrollView(
                child: InvoiceFormWidget(), // Rendered the InvoiceFormWidget
              ),
            ],
          ),
        ),
      ],
    );
  }
}
