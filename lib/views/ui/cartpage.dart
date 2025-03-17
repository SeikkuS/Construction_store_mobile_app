import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:construction_store_mobile_app/views/shared/custom_snackbar.dart'; // Adjust path
import 'package:construction_store_mobile_app/views/shared/export.dart'; // Adjust path for appstyle
import 'package:construction_store_mobile_app/views/ui/packages_page.dart'; // Adjust path for PackagesPage
import 'package:construction_store_mobile_app/controllers/cart_provider.dart'; // Adjust path
import 'package:construction_store_mobile_app/controllers/package_provider.dart'; // Adjust path
import 'package:construction_store_mobile_app/views/ui/checkout_page.dart'; // Import CheckoutPage

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _packageNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            final cartItems = cartProvider.cart;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Ionicons.close, color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Cart",
                      style: appstyle(36, Colors.black, FontWeight.bold),
                    ),
                    Text(
                      "Total: €${cartProvider.totalPrice.toStringAsFixed(2)}",
                      style: appstyle(18, Colors.black, FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final data = cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  spreadRadius: 5,
                                  blurRadius: 0.3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Image.asset(
                                    data['image'],
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      left: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.55,
                                          child: Text(
                                            data['name'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: appstyle(
                                              16,
                                              Colors.black,
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.55,
                                          child: Text(
                                            data['category'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: appstyle(
                                              14,
                                              Colors.grey,
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Text(
                                              data['price'].toString(),
                                              style: appstyle(
                                                18,
                                                Colors.black,
                                                FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 40),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                cartProvider.decrementQty(
                                                  data['key'],
                                                );
                                              },
                                              child: const Icon(
                                                Ionicons.remove_circle,
                                                size: 24,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data['qty'].toString(),
                                              style: appstyle(
                                                16,
                                                Colors.black,
                                                FontWeight.w600,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                cartProvider.incrementQty(
                                                  data['key'],
                                                );
                                              },
                                              child: const Icon(
                                                Ionicons.add_circle,
                                                size: 24,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      InkWell(
                                        onTap: () {
                                          cartProvider.deleteFromCart(
                                            data['key'],
                                          );
                                        },
                                        child: const Icon(
                                          Ionicons.trash_bin,
                                          size: 24,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (cartItems.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Empty Cart"),
                            content: const Text(
                              "Can't save an empty cart! Try adding a product into your cart first!",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      _showSavePackageDialog(context, cartItems);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Center(
                        child: Text(
                          "Save Your Cart as a Package",
                          style: appstyle(20, Colors.white, FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CheckOutButton(
                  label: "Proceed to Checkout",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckoutPage(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showSavePackageDialog(
    BuildContext context, // CartPage context
    List<Map<String, dynamic>> cartItems,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Save your cart as a Package"),
          content: SingleChildScrollView(
            child: TextField(
              controller: _packageNameController,
              decoration: const InputDecoration(hintText: "Enter package name"),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_packageNameController.text.isNotEmpty) {
                  // Create a deep copy of cartItems to ensure data persistence
                  List<Map<String, dynamic>> itemsToSave =
                      cartItems.map((item) {
                        return Map<String, dynamic>.from(item);
                      }).toList();

                  // Save the package using the dialog context
                  Provider.of<PackageProvider>(
                    dialogContext,
                    listen: false,
                  ).savePackage(_packageNameController.text, itemsToSave);

                  Navigator.pop(dialogContext); // Close the dialog

                  // Use the CartPage context for SnackBar and navigation
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(
                      "Package '${_packageNameController.text}' added. Tap to view your packages",
                      Icons.list,
                      () {
                        Navigator.push(
                          context, // Use CartPage context
                          MaterialPageRoute(
                            builder: (context) => const PackagesPage(),
                          ),
                        );
                      },
                    ),
                  );

                  _packageNameController.clear(); // Reset the text field
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
