import 'package:construction_store_mobile_app/views/shared/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:construction_store_mobile_app/views/shared/export_packages.dart';
import 'package:construction_store_mobile_app/views/shared/export.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.category, required this.id});

  final String id;
  final String category;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Future<Products>? _productFuture;

  @override
  void initState() {
    super.initState();
    final productNotifier = Provider.of<ProductNotifier>(
      context,
      listen: false,
    );
    productNotifier.getProductById(widget.id);
    _productFuture = productNotifier.product;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var favoritesNotifier = Provider.of<FavoritesNotifier>(
        context,
        listen: false,
      );
      favoritesNotifier.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Products>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Product not found"));
          } else {
            final product = snapshot.data!;
            return Consumer<ProductNotifier>(
              builder: (context, productNotifier, child) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      leadingWidth: 0,
                      title: Padding(
                        padding: EdgeInsets.only(left: 10.h),
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
                            Row(
                              children: [
                                Consumer<FavoritesNotifier>(
                                  builder: (context, favoritesNotifier, child) {
                                    bool isAnonymous =
                                        FirebaseAuth
                                            .instance
                                            .currentUser
                                            ?.isAnonymous ??
                                        true;
                                    bool isFavorited =
                                        !isAnonymous &&
                                        favoritesNotifier.ids.contains(
                                          widget.id,
                                        );
                                    return GestureDetector(
                                      onTap: () async {
                                        final scaffoldMessenger =
                                            ScaffoldMessenger.of(context);
                                        if (isAnonymous) {
                                          scaffoldMessenger.showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Please log in to add to favorites",
                                              ),
                                            ),
                                          );
                                        } else {
                                          if (isFavorited) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => Favorites(),
                                              ),
                                            ).then((_) {
                                              if (mounted) setState(() {});
                                            });
                                          } else {
                                            await favoritesNotifier.createFav({
                                              "id": product.id,
                                              "name": product.name,
                                              "price": product.price,
                                              "category": product.category,
                                              "image": product.imageUrl,
                                            });
                                            if (mounted) {
                                              setState(() {});
                                              scaffoldMessenger.showSnackBar(
                                                customSnackBar(
                                                  "${product.name} added to favorites!",
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      },
                                      child: Icon(
                                        isFavorited
                                            ? Ionicons.heart
                                            : Ionicons.heart_outline,
                                        color: Colors.black,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(width: 20.w),
                                GestureDetector(
                                  onTap: null,
                                  child: const Icon(
                                    Ionicons.ellipsis_horizontal,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
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
                            product.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
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
                                SizedBox(height: 10.h),
                                const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  color: Colors.black,
                                ),
                                SizedBox(height: 10.h),
                                SizedBox(
                                  width: 300.w,
                                  child: ReusableText(
                                    text: product.name,
                                    style: appstyle(
                                      26,
                                      Colors.black,
                                      FontWeight.w700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                ReusableText(
                                  text: product.description,
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
                                        await _createCart({
                                          "id": product.id,
                                          "name": product.name,
                                          "category": product.category,
                                          "image": product.imageUrl,
                                          "price": product.price,
                                          "qty": 1,
                                        });
                                        Navigator.pop(context);
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

  Future<void> _createCart(Map<String, dynamic> newCart) async {
    await Provider.of<CartProvider>(context, listen: false).addToCart(newCart);
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
        "${newCart['name']} added to cart!",
        icon: Icons.shopping_cart,
      ),
    );
  }
}
