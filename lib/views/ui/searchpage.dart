import 'package:construction_store_mobile_app/views/shared/custom_snackbar.dart'; // Adjust path
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:construction_store_mobile_app/controllers/product_provider.dart';
import 'package:construction_store_mobile_app/models/product_model.dart';
import 'package:construction_store_mobile_app/views/shared/appstyle.dart'; // Adjust path
import 'package:ionicons/ionicons.dart';
import 'package:construction_store_mobile_app/controllers/cart_provider.dart';
import 'package:construction_store_mobile_app/views/ui/cartpage.dart';

int _levenshteinDistance(String s, String t) {
  if (s == t) return 0;
  if (s.isEmpty) return t.length;
  if (t.isEmpty) return s.length;

  List<int> v0 = List.filled(t.length + 1, 0);
  List<int> v1 = List.filled(t.length + 1, 0);

  for (int i = 0; i <= t.length; i++) {
    v0[i] = i;
  }

  for (int i = 0; i < s.length; i++) {
    v1[0] = i + 1;
    for (int j = 0; j < t.length; j++) {
      int cost = (s[i] == t[j]) ? 0 : 1;
      v1[j + 1] = [
        v1[j] + 1,
        v0[j + 1] + 1,
        v0[j] + cost,
      ].reduce((a, b) => a < b ? a : b);
    }
    List<int> temp = v0;
    v0 = v1;
    v1 = temp;
  }

  return v0[t.length];
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List<Products> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final productNotifier = Provider.of<ProductNotifier>(
      context,
      listen: false,
    );
    await productNotifier.fetchAllProducts();
    setState(() {
      filteredProducts = productNotifier.allProducts;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    final productNotifier = Provider.of<ProductNotifier>(
      context,
      listen: false,
    );

    if (query.isEmpty) {
      setState(() {
        filteredProducts = productNotifier.allProducts;
      });
      return;
    }

    setState(() {
      filteredProducts =
          productNotifier.allProducts.where((product) {
            final nameLower = product.name.toLowerCase();
            final categoryLower = product.category.toLowerCase();
            final queryLower = query;

            if (nameLower.contains(queryLower) ||
                categoryLower.contains(queryLower)) {
              return true;
            }

            const int threshold = 2;
            final nameDistance = _levenshteinDistance(nameLower, queryLower);
            final categoryDistance = _levenshteinDistance(
              categoryLower,
              queryLower,
            );

            return nameDistance <= threshold || categoryDistance <= threshold;
          }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productNotifier = Provider.of<ProductNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: appstyle(16, Colors.black, FontWeight.normal),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body:
          productNotifier.isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredProducts.isEmpty && productNotifier.allProducts.isEmpty
              ? const Center(child: Text('No products available'))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductSearchItem(product: product);
                },
              ),
    );
  }
}

class ProductSearchItem extends StatefulWidget {
  final Products product;

  const ProductSearchItem({super.key, required this.product});

  @override
  State<ProductSearchItem> createState() => _ProductSearchItemState();
}

class _ProductSearchItemState extends State<ProductSearchItem> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
                  widget.product.imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: appstyle(16, Colors.black, FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.product.category,
                        style: appstyle(14, Colors.grey, FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "€${widget.product.price.toStringAsFixed(2)}",
                        style: appstyle(18, Colors.black, FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                          child: const Icon(
                            Ionicons.remove_circle,
                            size: 24,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          quantity.toString(),
                          style: appstyle(16, Colors.black, FontWeight.w600),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          child: const Icon(
                            Ionicons.add_circle,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: Icon(
                        Icons.add_shopping_cart,
                        size: 24,
                        color: Colors.black,
                      ),
                      tooltip: 'Add to Cart',
                      onPressed: () {
                        final cartProvider = Provider.of<CartProvider>(
                          context,
                          listen: false,
                        );
                        cartProvider.addToCart({
                          "id": widget.product.id,
                          "name": widget.product.name,
                          "category": widget.product.category,
                          "image": widget.product.imageUrl,
                          "price": widget.product.price,
                          "qty": quantity,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            "${widget.product.name} added to cart. Tap to view your cart",
                            Icons.shopping_cart,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CartPage(),
                                ),
                              );
                            },
                          ),
                        );
                        setState(() {
                          quantity = 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
