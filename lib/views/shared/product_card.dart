import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:construction_store_mobile_app/controllers/favorites_notifier.dart';
import 'package:construction_store_mobile_app/views/shared/appstyle.dart';
import 'package:construction_store_mobile_app/views/shared/reusable_text.dart';
import 'package:construction_store_mobile_app/views/ui/favoritespage.dart';

class ProductC extends StatefulWidget {
  const ProductC({
    super.key,
    required this.price,
    required this.category,
    required this.id,
    required this.name,
    required this.image,
  });

  final String price;
  final String category;
  final String id;
  final String name;
  final String image;

  @override
  State<ProductC> createState() => _ProductCState();
}

class _ProductCState extends State<ProductC> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    var favoritesNotifier = Provider.of<FavoritesNotifier>(
      context,
      listen: true,
    );
    favoritesNotifier.getFavorites();
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 20.w),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16.h)),
        child: Container(
          height: 325.h,
          width: 225.w,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: 1,
                blurRadius: 0.6,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 186.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.image),
                        fit: BoxFit.cover,
                      ), // USE NETWORK IMAGES ON REAL PAGE, LOCALLY RUN ATM THROUGH ASSETS FOLDER
                    ),
                  ),
                  Positioned(
                    right: 10.w,
                    top: 10.h,

                    child: GestureDetector(
                      onTap: () async {
                        if (favoritesNotifier.ids.contains(widget.id)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Favorites(),
                            ),
                          );
                        } else {
                          await favoritesNotifier.createFav({
                            "id": widget.id,
                            "name": widget.name,
                            "price": widget.price,
                            "category": widget.category,
                            "image": widget.image,
                          });
                        }
                        setState(() {});
                      },
                      child:
                          favoritesNotifier.ids.contains(widget.id)
                              ? const Icon(Ionicons.heart)
                              : const Icon(Ionicons.heart_outline),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    reusableText(
                      text: widget.name,
                      style: appstyleWithHeight(
                        34,
                        Colors.black,
                        FontWeight.bold,
                        1.1,
                      ),
                    ),
                    reusableText(
                      text: widget.category,
                      style: appstyleWithHeight(
                        18,
                        Colors.grey,
                        FontWeight.bold,
                        1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.price,
                      style: appstyle(30, Colors.black, FontWeight.w600),
                    ),
                    Row(
                      children: [
                        reusableText(
                          text: "Colors",
                          style: appstyle(18, Colors.grey, FontWeight.w500),
                        ),
                        SizedBox(width: 5.w),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = !selected;
                            });
                          },
                          child: Container(
                            width: 20.w, // Adjust size for a smaller circle
                            height: 20.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // Makes it a circle
                              color:
                                  selected ? Colors.grey : Colors.grey.shade300,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ), // Optional border
                            ),
                          ),
                        ),
                      ],
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
