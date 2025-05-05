import 'package:flutter/material.dart';
import '../logo_widget.dart';
import '../services/sales_service.dart';
import '../widgets/sales_analytics_card.dart';
import '../widgets/sales_form_widget.dart';
import '../models/sales_model.dart';
import '../widgets/sales_chart_widget.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final SalesService _salesService = SalesService();
  
  Widget _buildAnalyticsDashboard() {
    return StreamBuilder<List<SaleModel>>(
      stream: _salesService.getTodaySales(),
      builder: (context, todaySalesSnapshot) {
        return StreamBuilder<List<SaleModel>>(
          stream: _salesService.getWeeklySales(),
          builder: (context, weeklySalesSnapshot) {
            return StreamBuilder<List<SaleModel>>(
              stream: _salesService.getMonthlySales(),
              builder: (context, monthlySalesSnapshot) {
                return StreamBuilder<List<SaleModel>>(
                  stream: _salesService.getDuePayments(),
                  builder: (context, duePaymentsSnapshot) {
                    return StreamBuilder<Map<String, int>>(
                      stream: _salesService.getPaymentMethodStats(),
                      builder: (context, paymentStatsSnapshot) {
                        // Calculate values
                        final todayTotal = todaySalesSnapshot.hasData 
                            ? _salesService.calculateTotalAmount(todaySalesSnapshot.data!)
                            : 0.0;
                        final weeklyTotal = weeklySalesSnapshot.hasData
                            ? _salesService.calculateTotalAmount(weeklySalesSnapshot.data!)
                            : 0.0;
                        final monthlyTotal = monthlySalesSnapshot.hasData
                            ? _salesService.calculateTotalAmount(monthlySalesSnapshot.data!)
                            : 0.0;
                        final dueAmount = duePaymentsSnapshot.hasData
                            ? _salesService.calculateTotalAmount(duePaymentsSnapshot.data!)
                            : 0.0;

                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: SalesAnalyticsCard(
                                      title: "Today's Sales",
                                      value: 'SLL ${todayTotal.toStringAsFixed(2)}',
                                      icon: Icons.today,
                                      color: const Color(0xFF6621DC),
                                      subtitle: '${todaySalesSnapshot.data?.length ?? 0} sales today',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: SalesAnalyticsCard(
                                      title: 'Weekly Sales',
                                      value: 'SLL ${weeklyTotal.toStringAsFixed(2)}',
                                      icon: Icons.calendar_view_week,
                                      color: const Color(0xFF1E88E5),
                                      subtitle: '${weeklySalesSnapshot.data?.length ?? 0} sales this week',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: SalesAnalyticsCard(
                                      title: 'Monthly Sales',
                                      value: 'SLL ${monthlyTotal.toStringAsFixed(2)}',
                                      icon: Icons.calendar_month,
                                      color: const Color(0xFF43A047),
                                      subtitle: '${monthlySalesSnapshot.data?.length ?? 0} sales this month',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: SalesAnalyticsCard(
                                      title: 'Due Payments',
                                      value: 'SLL ${dueAmount.toStringAsFixed(2)}',
                                      icon: Icons.payment,
                                      color: const Color(0xFFE53935),
                                      subtitle: '${duePaymentsSnapshot.data?.length ?? 0} pending payments',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              if (weeklySalesSnapshot.hasData && weeklySalesSnapshot.data!.isNotEmpty)
                                SalesChartWidget(
                                  sales: weeklySalesSnapshot.data!,
                                  color: const Color(0xFF1E88E5),
                                  title: 'Weekly Sales Trend',
                                ),
                              const SizedBox(height: 24),
                              if (monthlySalesSnapshot.hasData && monthlySalesSnapshot.data!.isNotEmpty)
                                SalesChartWidget(
                                  sales: monthlySalesSnapshot.data!,
                                  color: const Color(0xFF43A047),
                                  title: 'Monthly Sales Trend',
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

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
        decoration: const BoxDecoration(
          color: Color(0xFF6621DC),
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
        centerTitle: true,
        title: const LogoWidget(
          size: 60,
          animate: false,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF6621DC),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LogoWidget(
                    size: 50,
                    animate: false,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                // Add logout logic
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _buildAnalyticsDashboard(),
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