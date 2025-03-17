import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:construction_store_mobile_app/controllers/order_provider.dart'; // Adjust path
import 'package:construction_store_mobile_app/views/ui/order_details_page.dart'; // Add this import

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    // Delay getOrders until after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;
    final isLoading = orderProvider.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : orders.isEmpty
              ? const Center(child: Text("No orders found."))
              : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ListTile(
                    title: Text('Order #${order['id']}'),
                    subtitle: Text(
                      'Total: €${order['amount'].toStringAsFixed(2)}',
                    ),
                    trailing: Text(order['status']),
                    onTap: () {
                      // Navigate to OrderDetailsPage with the selected order
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(order: order),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
