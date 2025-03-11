import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle appstyle(double size, Color color, FontWeight fw) {
  return GoogleFonts.poppins(fontSize: size.sp, color: color, fontWeight: fw);
}

TextStyle appstyleWithHeight(
  double size,
  Color color,
  FontWeight fw,
  double ht,
) {
  return GoogleFonts.poppins(
    fontSize: size.sp,
    color: color,
    fontWeight: fw,
    height: ht,
  );
}
