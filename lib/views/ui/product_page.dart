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
  final PageController pageController = PageController();
  final _cartBox = Hive.box('cart_box');

  // Local variable to track the active page index
  int _activePage = 0;

  Future<void> _createCart(Map<String, dynamic> newCart) async {
    final sizesCopy = List<String>.from(newCart["sizes"]);
    newCart["sizes"] = sizesCopy;
    await _cartBox.add(newCart);
  }

  @override
  Widget build(BuildContext context) {
    var favoritesNotifier = Provider.of<FavoritesNotifier>(
      context,
      listen: true,
    );
    favoritesNotifier.getFavorites();
    var productNotifier = Provider.of<ProductNotifier>(context);
    productNotifier.getProducts(widget.category, widget.id);

    return Scaffold(
      // This lets the flexible space fill behind the app bar completely
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
                    // SliverAppBar for the image carousel
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
                                productNotifier.productSizes.clear();
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
                        // Remove any default padding
                        titlePadding: EdgeInsets.zero,
                        background: SizedBox.expand(
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: product!.imageList.length,
                            controller: pageController,
                            onPageChanged: (page) {
                              setState(() {
                                _activePage = page;
                              });
                            },
                            itemBuilder: (context, int index) {
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Using BoxFit.cover to fully fill the space
                                  Image.asset(
                                    product.imageList[index],
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 98.h,
                                    right: 20.w,
                                    child: Consumer<FavoritesNotifier>(
                                      builder: (
                                        context,
                                        favoritesNotifier,
                                        child,
                                      ) {
                                        return GestureDetector(
                                          onTap: () async {
                                            if (favoritesNotifier.ids.contains(
                                              widget.id,
                                            )) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          const Favorites(),
                                                ),
                                              );
                                            } else {
                                              await favoritesNotifier.createFav(
                                                {
                                                  "id": product.id,
                                                  "name": product.name,
                                                  "price": product.price,
                                                  "category": product.category,
                                                  "image": product.image,
                                                },
                                              );
                                            }
                                            setState(() {});
                                          },
                                          child:
                                              favoritesNotifier.ids.contains(
                                                    product.id,
                                                  )
                                                  ? const Icon(Ionicons.heart)
                                                  : const Icon(
                                                    Ionicons.heart_outline,
                                                  ),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10.h,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List<Widget>.generate(
                                        product.imageList.length,
                                        (index) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          child: CircleAvatar(
                                            radius: 5,
                                            backgroundColor:
                                                _activePage != index
                                                    ? Colors.grey
                                                    : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // SliverToBoxAdapter for product details
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
                            reusableText(
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
                                    // Handle rating update here
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
                                Row(
                                  children: [
                                    Text(
                                      "Colors",
                                      style: appstyle(
                                        20,
                                        Colors.black,
                                        FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    const CircleAvatar(
                                      radius: 7,
                                      backgroundColor: Colors.black,
                                    ),
                                    SizedBox(width: 5.w),
                                    const CircleAvatar(
                                      radius: 7,
                                      backgroundColor: Colors.grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Select size",
                                      style: appstyle(
                                        20,
                                        Colors.black,
                                        FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 20.w),
                                    Text(
                                      "View size guide",
                                      style: appstyle(
                                        20,
                                        Colors.grey,
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                SizedBox(
                                  height: 40.h,
                                  child: ListView.builder(
                                    itemCount:
                                        productNotifier.productSizes.length,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      final sizes =
                                          productNotifier.productSizes[index];
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.0.w,
                                        ),
                                        child: ChoiceChip(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              60.h,
                                            ),
                                            side: const BorderSide(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          disabledColor: Colors.white,
                                          label: Text(
                                            sizes['size'],
                                            style: appstyle(
                                              18,
                                              sizes['isSelected']
                                                  ? Colors.white
                                                  : Colors.black,
                                              FontWeight.w500,
                                            ),
                                          ),
                                          selectedColor: Colors.black,
                                          showCheckmark: false,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8.0.h,
                                            horizontal: 8.0.w,
                                          ),
                                          selected: sizes['isSelected'],
                                          onSelected: (newState) {
                                            productNotifier.toggleSizeSelection(
                                              index,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            const Divider(
                              indent: 10,
                              endIndent: 10,
                              color: Colors.black,
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: 300.w,
                              child: Text(
                                product.title,
                                style: appstyle(
                                  26,
                                  Colors.black,
                                  FontWeight.w700,
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
                                    final selectedSizes = List<String>.from(
                                      productNotifier.sizes,
                                    );
                                    await _createCart({
                                      "id": product.id,
                                      "name": product.name,
                                      "category": product.category,
                                      "sizes": selectedSizes,
                                      "image": product.image,
                                      "price": product.price,
                                      "qty": 1,
                                    });
                                    productNotifier.sizes.clear();
                                    Navigator.pop(context);
                                  },
                                  label: "Add to Cart",
                                ),
                              ),
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
}
