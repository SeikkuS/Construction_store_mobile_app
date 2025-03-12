import 'package:flutter/material.dart';
import 'package:construction_store_mobile_app/views/shared/export_packages.dart';
import 'package:construction_store_mobile_app/views/shared/export.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.category, required this.id});

  final String id;
  final String category;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    // Load the product when the page is initialized
    var productNotifier = Provider.of<ProductNotifier>(context, listen: false);
    productNotifier.getProductById(widget.id); // Use the new method
  }

  @override
  Widget build(BuildContext context) {
    var favoritesNotifier = Provider.of<FavoritesNotifier>(
      context,
      listen: true,
    );
    favoritesNotifier.getFavorites();

    var productNotifier = Provider.of<ProductNotifier>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Products>(
        future: productNotifier.product,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error ${snapshot.error}"));
          } else {
            final product = snapshot.data;

            return Consumer<ProductNotifier>(
              builder: (context, productNotifier, child) {
                return CustomScrollView(
                  slivers: [
                    // SliverAppBar for the product image.
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      leadingWidth: 0,
                      title: Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Ionicons.close,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: null,
                              child: const Icon(
                                Ionicons.ellipsis_horizontal,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pinned: true,
                      snap: false,
                      floating: true,
                      backgroundColor: Colors.transparent,
                      expandedHeight: 401.h,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.zero,
                        background: SizedBox.expand(
                          child: Image.asset(
                            product!.imageUrl, // Only one image
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // SliverToBoxAdapter for product details.
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30.h),
                          ),
                        ),
                        padding: EdgeInsets.all(12.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                              text: product.name,
                              style: appstyle(
                                40,
                                Colors.black,
                                FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  product.category,
                                  style: appstyle(
                                    20,
                                    Colors.grey,
                                    FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                RatingBar.builder(
                                  initialRating: 4,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 22.w,
                                  itemPadding: const EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                  itemBuilder:
                                      (context, _) => const Icon(
                                        Icons.star,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                  onRatingUpdate: (rating) {
                                    // Handle rating update.
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "€${product.price}",
                                  style: appstyle(
                                    26,
                                    Colors.black,
                                    FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Column(
                              children: [
                                // Removed size selection as we don't need it anymore
                                SizedBox(height: 10.h),
                                const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  color: Colors.black,
                                ),
                                SizedBox(height: 10.h),
                                SizedBox(
                                  width: 300.w,
                                  child: Flexible(
                                    child: Text(
                                      product.name,
                                      style: appstyle(
                                        26,
                                        Colors.black,
                                        FontWeight.w700,
                                      ),
                                      overflow:
                                          TextOverflow
                                              .ellipsis, // Optionally truncate overflowed text with an ellipsis
                                      maxLines:
                                          2, // Optionally limit the number of lines for the name
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  product.description,
                                  textAlign: TextAlign.justify,
                                  maxLines: 4,
                                  style: appstyle(
                                    14,
                                    Colors.black,
                                    FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 0.h),
                                    child: CheckOutButton(
                                      onTap: () async {
                                        // Make sure to pass the correct product information to _createCart
                                        await _createCart({
                                          "id":
                                              product
                                                  .id, // Use the product ID directly
                                          "name": product.name,
                                          "category": product.category,
                                          "image": product.imageUrl,
                                          "price": product.price,
                                          "qty": 1,
                                        });
                                        Navigator.pop(
                                          context,
                                        ); // Close the Product page
                                      },
                                      label: "Add to Cart",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  // Removed _createCart handling of sizes as it's no longer needed
  Future<void> _createCart(Map<String, dynamic> newCart) async {
    await Provider.of<CartProvider>(context, listen: false).addToCart(newCart);
  }
}
