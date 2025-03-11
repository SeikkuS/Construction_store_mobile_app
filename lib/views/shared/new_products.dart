import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewProducts extends StatelessWidget {
  const NewProducts({super.key, required this.imagePath, this.onTap});

  final String imagePath;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16.h)),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 1,
              blurRadius: 0.8,
              offset: Offset(0, 1),
            ),
          ],
        ),
        height: 100.h,
        width: 104.w,
        child: Image.asset(imagePath),
        //  If you want to use network images instead of local ones,
        //  change this Image.asset to CachedNetworkImage
        //  and insert the URL into the imagePath value.
        //  This will also require you to change values in the .json
      ),
    );
  }
}
