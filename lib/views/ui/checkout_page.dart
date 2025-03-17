import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:construction_store_mobile_app/controllers/cart_provider.dart'; // Adjust path
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction_store_mobile_app/views/ui/orders_page.dart'; // Add this

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  CheckoutPageState createState() => CheckoutPageState();
}

class CheckoutPageState extends State<CheckoutPage> {
  String? clientSecret;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize Stripe with your publishable key
    Stripe.publishableKey =
        'pk_test_51R3bYqFLhHIosR3sS20tLw3qH10Aw6M2mwxIUHkgRL1rpSDYh1jXY96yV8Swqk4rfvsxf4XWUg6VB0DLhhYO1XfW00DrO7YF9a'; // Replace with your key
  }

  /// Creates a Payment Intent by calling the backend
  Future<void> createPaymentIntent(double amount) async {
    try {
      final url = Uri.parse(
        'http://192.168.1.2:3000/create-payment-intent',
      ); // Replace with your backend URL
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'amount': amount}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          clientSecret = data['clientSecret'];
        });
      } else {
        throw Exception(
          'Failed to create payment intent: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error creating payment intent: $e');
    }
  }

  /// Initiates the payment process using flutter_stripe
  Future<void> makePayment() async {
    if (clientSecret == null) return;
    try {
      // Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret!,
          merchantDisplayName: 'Construction Store',
        ),
      );
      // Present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();
      // Create the order in Firestore
      await createOrder();
      // Show success message with navigation to OrdersPage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Payment successful!'),
          action: SnackBarAction(
            label: 'View Orders',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersPage()),
              );
            },
          ),
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    }
  }

  /// Creates an order in Firestore after successful payment
  Future<void> createOrder() async {
    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final cartItems = cartProvider.cart;
      final totalPrice = cartProvider.totalPrice;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User not logged in');
      }

      // Create the order data
      Map<String, dynamic> order = {
        'userId': user.uid,
        'amount': totalPrice,
        'status': 'processing', // Initial status
        'createdAt':
            FieldValue.serverTimestamp(), // Timestamp of order creation
        'items':
            cartItems
                .map(
                  (item) => {
                    'productId': item['id'],
                    'quantity': item['qty'],
                    'price': item['price'],
                  },
                )
                .toList(),
      };

      // Store the order in the "orders" collection
      await FirebaseFirestore.instance.collection('orders').add(order);
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cart;
    final totalPrice = cartProvider.totalPrice;

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Column(
        children: [
          // Cart items list
          Expanded(
            child:
                cartItems.isEmpty
                    ? const Center(child: Text("Your cart is empty"))
                    : ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return ListTile(
                          leading: Image.asset(
                            item['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item['name']),
                          subtitle: Text('Quantity: ${item['qty']}'),
                          trailing: Text(
                            '€${(item['price'] * item['qty']).toStringAsFixed(2)}',
                          ),
                        );
                      },
                    ),
          ),
          // Total price and Pay Now button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: €${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      isLoading || cartItems.isEmpty
                          ? null
                          : () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await createPaymentIntent(totalPrice);
                              await makePayment();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Pay Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
