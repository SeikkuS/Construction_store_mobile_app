import 'package:construction_store_mobile_app/views/shared/export_packages.dart';
import 'package:construction_store_mobile_app/views/shared/export.dart';
import 'package:construction_store_mobile_app/views/ui/mainscreen.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCart();

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
                    Navigator.pop(context);
                  },
                  child: Icon(Ionicons.close, color: Colors.black),
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
                        padding: EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.11,
                            width: MediaQuery.of(context).size.width,

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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
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
                                        Positioned(
                                          bottom: -2,
                                          child: GestureDetector(
                                            onTap: () {
                                              cartProvider.deleteCart(
                                                data['key'],
                                              );
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => MainScreen(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 40,
                                              height: 30,
                                              decoration: const BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(12),
                                                ),
                                              ),
                                              child: const Icon(
                                                Ionicons.trash_outline,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 12,
                                        left: 20,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['name'],
                                            style: appstyle(
                                              16,
                                              Colors.black,
                                              FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            data['category'],
                                            style: appstyle(
                                              14,
                                              Colors.grey,
                                              FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                data['price'],
                                                style: appstyle(
                                                  18,
                                                  Colors.black,
                                                  FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 40),
                                              Text(
                                                "Size",
                                                style: appstyle(
                                                  18,
                                                  Colors.black,
                                                  FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 40),
                                              Text(
                                                data['sizes'].join(", "),
                                                style: appstyle(
                                                  18,
                                                  Colors.black,
                                                  FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {},
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
                                              onTap: () {},
                                              child: const Icon(
                                                Ionicons.add_circle,
                                                size: 24,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
