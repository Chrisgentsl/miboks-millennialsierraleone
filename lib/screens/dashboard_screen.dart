import 'package:flutter/material.dart';
import 'dart:math' show max;
import '../logo_widget.dart';
import '../widgets/welcome_message_widget.dart';
import '../widgets/new_button.dart';
import '../widgets/animated_analytic_card.dart';
import '../widgets/warning_alert_icon.dart';
import '../widgets/animated_table_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: LogoWidget(
            size: 40, // Adjust size for the top-left corner
            animate: false, // Disable animation for static placement
          ),
        ),
        title: const Text('Dashboard'),
        actions: [],
      ),
      body: Column(
        children: [
          Container(
            height: 1.0,
            color: Colors.black, // Black horizontal line
          ),
          const WelcomeMessageWidget(), // Added the WelcomeMessageWidget under the horizontal line
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Monitor Inventory and Invoices',
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
              child: NewButton(
                onPressed: () {
                  print('New button pressed');
                },
                size: const Size(150, 50), // Properly passed the size parameter
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(), // Enable scrolling without scrollbar
              child: Wrap(
                spacing: 16.0, // Horizontal spacing between cards
                runSpacing: 16.0, // Vertical spacing between cards
                alignment:
                    WrapAlignment.center, // Center cards on larger screens
                children: [
                  SizedBox(
                    // Responsive width based on screen size
                    width: isSmallScreen ? (screenWidth - 48) / 2 : 200,
                    height: 116,
                    child: Stack(
                      children: const [
                        AnimatedAnalyticCard(
                          icon: Icons.inventory,
                          title: 'Low Stock',
                          value:
                              '', // Removed dummy data for real-time data fetching
                          color: Color(0xFF6621DC),
                          backgroundColor: Colors.grey,
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: WarningAlertIcon(
                            warningCount: '3', // Example warning count
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    // Responsive width based on screen size
                    width: isSmallScreen ? (screenWidth - 48) / 2 : 200,
                    height: 116,
                    child: const AnimatedAnalyticCard(
                      icon: Icons.currency_exchange, // Changed to represent SLL
                      title: 'Total Sales',
                      value:
                          '', // Removed dummy data for real-time data fetching
                      color: Color(0xFF6621DC), // Updated icon color
                      backgroundColor: Colors.grey, // Grey background for icon
                    ),
                  ),
                  SizedBox(
                    // Responsive width based on screen size
                    width: isSmallScreen ? (screenWidth - 48) / 2 : 200,
                    height: 116,
                    child: Stack(
                      children: [
                        const AnimatedAnalyticCard(
                          icon: Icons.receipt,
                          title: 'Invoices',
                          value:
                              '', // Removed dummy data for real-time data fetching
                          color: Color(0xFF6621DC), // Updated icon color
                          backgroundColor:
                              Colors.grey, // Grey background for icon
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.arrow_upward,
                                color: Colors.green, // Green arrow icon
                                size: 16.0,
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                '25%', // Example percentage for invoices
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    // Responsive width based on screen size
                    width: isSmallScreen ? (screenWidth - 48) / 2 : 200,
                    height: 116,
                    child: Stack(
                      children: [
                        const AnimatedAnalyticCard(
                          icon: Icons.people,
                          title: 'Customers',
                          value:
                              '', // Removed dummy data for real-time data fetching
                          color: Color(0xFF6621DC), // Updated icon color
                          backgroundColor:
                              Colors.grey, // Grey background for icon
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.arrow_upward,
                                color:
                                    Colors
                                        .blue, // Blue arrow icon for customers
                                size: 16.0,
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                '15%', // Example percentage for new customers
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Wrap the table widget in a container with horizontal scroll for small screens
          SizedBox(
            width: screenWidth,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                // Ensure table has minimum width on small screens
                width: isSmallScreen ? max(screenWidth, 500) : screenWidth,
                child: const AnimatedTableWidget(),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Opacity(
                    opacity: 0.1, // Set opacity for background effect
                    child: LogoWidget(
                      size: 300, // Increased size for background
                      animate: false, // Disable animation for background
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Add other widgets or content here if needed
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
