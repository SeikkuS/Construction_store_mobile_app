import 'package:construction_store_mobile_app/views/shared/custom_snackbar.dart'; // Adjust path
import 'package:construction_store_mobile_app/views/ui/packages_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:construction_store_mobile_app/controllers/cart_provider.dart';
import 'package:construction_store_mobile_app/controllers/package_provider.dart';
import 'package:construction_store_mobile_app/views/ui/cartpage.dart';
import 'package:ionicons/ionicons.dart';

class PackageDetailPage extends StatefulWidget {
  final Map<String, dynamic> package;

  const PackageDetailPage({super.key, required this.package});

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage> {
  late List<Map<String, dynamic>> _packageItems;
  late List<Map<String, dynamic>> _originalItems;

  @override
  void initState() {
    super.initState();
    _originalItems =
        widget.package['items'].map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();
    _packageItems =
        widget.package['items'].map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();
  }

  void _addPackageToCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    for (var item in _packageItems) {
      final cartItem = Map<String, dynamic>.from(item);
      cartProvider.addToCart(cartItem);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
        "${widget.package['name']} added to cart. Tap to view your cart",
        Icons.shopping_cart,
        () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartPage()),
          );
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_areItemsEqual(_packageItems, _originalItems)) {
      return true;
    }

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Save Changes?"),
          content: Text(
            "Do you want to save changes to '${widget.package['name']}' package?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    if (shouldSave == true) {
      Provider.of<PackageProvider>(context, listen: false).updatePackage(
        widget.package['key'],
        widget.package['name'],
        _packageItems,
      );
    } else if (shouldSave == false) {
      setState(() {
        _packageItems = List.from(_originalItems);
      });
    }
    return true;
  }

  bool _areItemsEqual(
    List<Map<String, dynamic>> items1,
    List<Map<String, dynamic>> items2,
  ) {
    if (items1.length != items2.length) return false;
    for (int i = 0; i < items1.length; i++) {
      if (items1[i]['id'] != items2[i]['id'] ||
          items1[i]['qty'] != items2[i]['qty']) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.package['name']),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: _addPackageToCart,
              tooltip: 'Add Package to Cart',
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: _packageItems.length,
          itemBuilder: (context, index) {
            final item = _packageItems[index];
            return ListTile(
              leading: Image.asset(
                item['image'],
                width: 50,
                height: 50,
                fit: BoxFit.fill,
              ),
              title: Text(item['name']),
              subtitle: Text("€${item['price'].toStringAsFixed(2)}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Ionicons.remove_circle),
                    onPressed: () {
                      setState(() {
                        if (item['qty'] > 1) {
                          item['qty']--;
                        } else {
                          _packageItems.removeAt(index);
                        }
                      });
                    },
                  ),
                  Text(item['qty'].toString()),
                  IconButton(
                    icon: const Icon(Ionicons.add_circle),
                    onPressed: () {
                      setState(() {
                        item['qty']++;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Ionicons.trash_bin),
                    onPressed: () {
                      setState(() {
                        _packageItems.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
