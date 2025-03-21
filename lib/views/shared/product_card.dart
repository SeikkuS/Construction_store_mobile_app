import 'package:construction_store_mobile_app/views/shared/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:construction_store_mobile_app/controllers/favorites_notifier.dart';
import 'package:construction_store_mobile_app/views/shared/appstyle.dart';
import 'package:construction_store_mobile_app/views/shared/reusable_text.dart';
import 'package:construction_store_mobile_app/views/ui/favoritespage.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 186.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.image),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Consumer<FavoritesNotifier>(
                        builder: (context, favoritesNotifier, child) {
                          bool isAnonymous =
                              FirebaseAuth.instance.currentUser?.isAnonymous ??
                              true;
                          bool isFavorited =
                              !isAnonymous &&
                              favoritesNotifier.ids.contains(widget.id);
                          return GestureDetector(
                            onTap: () async {
                              final scaffoldMessenger = ScaffoldMessenger.of(
                                context,
                              );
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
                                  scaffoldMessenger.showSnackBar(
                                    customSnackBar(
                                      "${widget.name} added to favorites. Tap to view your favorites",
                                      Icons.favorite,
                                      () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Favorites(),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              }
                            },
                            child: Icon(
                              isFavorited
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: widget.name,
                      style: appstyleWithHeight(
                        34,
                        Colors.black,
                        FontWeight.bold,
                        1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    ReusableText(
                      text: widget.category,
                      style: appstyleWithHeight(
                        18,
                        Colors.grey,
                        FontWeight.bold,
                        1.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.price,
                      style: appstyle(30, Colors.black, FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        ReusableText(
                          text: "Colors",
                          style: appstyle(18, Colors.grey, FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 5.w),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = !selected;
                            });
                          },
                          child: Container(
                            width: 20.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  selected ? Colors.grey : Colors.grey.shade300,
                              border: Border.all(color: Colors.black, width: 1),
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
