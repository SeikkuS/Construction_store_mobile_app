import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:construction_store_mobile_app/models/product_model.dart';
import 'package:construction_store_mobile_app/views/shared/appstyle.dart';
import 'package:construction_store_mobile_app/views/shared/new_products.dart';
import 'package:construction_store_mobile_app/views/shared/product_card.dart';
import 'package:construction_store_mobile_app/views/shared/reusable_text.dart';
import 'package:construction_store_mobile_app/views/ui/product_by_cart.dart';
import 'package:construction_store_mobile_app/views/ui/product_page.dart';

class HomeWidget extends StatelessWidget {
  final List<Products> products;
  final int tabIndex;

  const HomeWidget({super.key, required this.products, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 325.h,
          child: ListView.builder(
            itemCount: products.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
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
                child: SizedBox(
                  width:
                      253.w, // 225.w (card width) + 8.w (left padding) + 20.w (right padding)
                  child: ProductC(
                    price: "${product.price}€",
                    category: product.category,
                    id: product.id,
                    name: product.name,
                    image: product.imageUrl,
                  ),
                ),
              );
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
                  ReusableText(
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
                        ReusableText(
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
          child: ListView.builder(
            itemCount: products.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: EdgeInsets.all(8.0.h),
                child: NewProducts(
                  onTap: () {
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
                  imagePath: product.imageUrl,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
