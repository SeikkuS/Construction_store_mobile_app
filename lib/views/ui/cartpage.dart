import 'package:construction_store_mobile_app/views/shared/export_packages.dart';
import 'package:construction_store_mobile_app/views/shared/export.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    // Fetch the cart items from Firestore when the page is initialized
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.getCart();
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    // Simply pop the current screen to go back to the previous screen (MainScreen)
                    Navigator.pop(context); // Return to the MainScreen
                  },
                  child: const Icon(Ionicons.close, color: Colors.black),
                ),
                Text(
                  "My Cart",
                  style: appstyle(36, Colors.black, FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: ListView.builder(
                    itemCount: cartProvider.cart.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final data = cartProvider.cart[index];
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
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
                                // Adjust the product information column width
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 12, left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text widget with maxLines and overflow handling to prevent text overflow
                                        SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.55, // limit the width of the name
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
                                        // Category text with maxLines and overflow handling
                                        SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.55, // limit the width of the category
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
                                        const SizedBox(
                                          height: 10,
                                        ), // Added extra spacing below the price
                                      ],
                                    ),
                                  ),
                                ),
                                // Adjust the width of the quantity and trash section
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Quantity section
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
                                      SizedBox(width: 20.w), // space between
                                      // Trash Icon (Removal button)
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
              ],
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: CheckOutButton(label: "Proceed to Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}
