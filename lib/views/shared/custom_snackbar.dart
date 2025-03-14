import 'package:flutter/material.dart';
import 'package:construction_store_mobile_app/views/shared/appstyle.dart'; // Replace with your app's style file

SnackBar customSnackBar(
  String message,
  IconData navigateIcon,
  VoidCallback onNavigate,
) {
  return SnackBar(
    content: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: appstyle(16, Colors.white, FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8.0),
          GestureDetector(
            onTap: onNavigate,
            child: Icon(navigateIcon, color: Colors.white),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 3),
  );
}
