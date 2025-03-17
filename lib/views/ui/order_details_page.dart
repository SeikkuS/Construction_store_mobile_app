import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final items = order['items'] as List<dynamic>? ?? [];
    final createdAt = order['createdAt'] as Timestamp?;

    return Scaffold(
      appBar: AppBar(title: Text('Order #${order['id']}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Text(
              'Total: €${order['amount'].toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${order['status']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Ordered on: ${createdAt?.toDate().toString() ?? 'Unknown'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // Order Items Header
            const Text(
              'Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child:
                  items.isEmpty
                      ? const Center(
                        child: Text('No items found in this order.'),
                      )
                      : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return FutureBuilder<DocumentSnapshot>(
                            future:
                                FirebaseFirestore.instance
                                    .collection('products')
                                    .doc(item['productId'])
                                    .get(),
                            builder: (context, snapshot) {
                              // Loading state
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const ListTile(
                                  title: Text('Loading...'),
                                );
                              }
                              // Error or no data state
                              if (snapshot.hasError ||
                                  !snapshot.hasData ||
                                  !snapshot.data!.exists) {
                                return ListTile(
                                  title: const Text('Product not found'),
                                  subtitle: Text(
                                    'Quantity: ${item['quantity']}',
                                  ),
                                  trailing: Text(
                                    '€${item['price'].toStringAsFixed(2)}',
                                  ),
                                );
                              }
                              // Success: Display product details
                              final product =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return ListTile(
                                title: Text(
                                  product['name'] ?? 'Unknown Product',
                                ),
                                subtitle: Text('Quantity: ${item['quantity']}'),
                                trailing: Text(
                                  '€${item['price'].toStringAsFixed(2)}',
                                ),
                              );
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
