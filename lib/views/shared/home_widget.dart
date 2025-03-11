import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shope_collection_app/controllers/product_provider.dart';
import 'package:shope_collection_app/models/product_model.dart';
import 'package:shope_collection_app/views/shared/appstyle.dart';
import 'package:shope_collection_app/views/shared/new_products.dart';
import 'package:shope_collection_app/views/shared/product_card.dart';
import 'package:shope_collection_app/views/shared/reusable_text.dart';
import 'package:shope_collection_app/views/ui/product_by_cart.dart';
import 'package:shope_collection_app/views/ui/product_page.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
    required Future<List<Products>> ruuvit,
    required this.tabIndex,
  }) : _ruuvit = ruuvit;

  final Future<List<Products>> _ruuvit;
  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    var productNotifier = Provider.of<ProductNotifier>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 325.h,
          child: FutureBuilder<List<Products>>(
            future: _ruuvit,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error ${snapshot.error}");
              } else {
                final ruuvi = snapshot.data;
                return ListView.builder(
                  itemCount: ruuvi!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        productNotifier.productSizes = product.sizes;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ProductPage(
                                  category: product.category,
                                  id: product.id,
                                ),
                          ),
                        );
                      },
                      child: ProductC(
                        price: "${product.price}€",
                        category: product.category,
                        id: product.id,
                        name: product.name,
                        image: product.image, //INSERT IMAGE NETWORK URL
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  reusableText(
                    text: "Uutuudet",
                    style: appstyle(24, Colors.black, FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ProductByCart(tabIndex: tabIndex),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        reusableText(
                          text: "Näytä kaikki",
                          style: appstyle(22, Colors.black, FontWeight.w500),
                        ),
                        Icon(Ionicons.arrow_forward, size: 22.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 99.h,
          child: FutureBuilder<List<Products>>(
            future: _ruuvit,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error ${snapshot.error}");
              } else {
                final ruuvi = snapshot.data;
                return ListView.builder(
                  itemCount: ruuvi!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];
                    return Padding(
                      padding: EdgeInsets.all(8.0.h),
                      child: NewProducts(
                        onTap: () {
                          productNotifier.productSizes = product.sizes;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ProductPage(
                                    category: product.category,
                                    id: product.id,
                                  ),
                            ),
                          );
                        },
                        imagePath: product.image,
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
