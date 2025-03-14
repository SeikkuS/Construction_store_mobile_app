import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:construction_store_mobile_app/models/product_model.dart';
import 'package:construction_store_mobile_app/views/shared/stagger_tile.dart';

class LatestProducts extends StatelessWidget {
  const LatestProducts({super.key, required this.products});

  final List<Products> products;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      crossAxisSpacing: 20.w,
      mainAxisSpacing: 16.h,
      itemCount: products.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final product = products[index];
        double tileHeight = (index % 4 == 1 || index % 4 == 3) ? 285.h : 252.h;
        return StaggerTile(
          imagePath: product.imageUrl,
          name: product.name,
          price: "${product.price}€",
          height: tileHeight,
        );
      },
    );
  }
}
