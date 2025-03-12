import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:construction_store_mobile_app/views/shared/appstyle.dart';
import 'package:construction_store_mobile_app/views/shared/reusable_text.dart';

class StaggerTile extends StatefulWidget {
  const StaggerTile({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
    required this.height,
  });

  final String imagePath;
  final String name;
  final String price;
  final double height;

  @override
  State<StaggerTile> createState() => _StaggerTileState();
}

class _StaggerTileState extends State<StaggerTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 12.h),
              height: 75.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    text: widget.name,
                    style: appstyleWithHeight(
                      20,
                      Colors.black,
                      FontWeight.w700,
                      1,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ReusableText(
                    text: widget.price,
                    style: appstyleWithHeight(
                      20,
                      Colors.black,
                      FontWeight.w500,
                      1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
