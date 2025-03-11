import 'package:flutter/material.dart';
import 'package:construction_store_mobile_app/views/shared/appstyle.dart';

class CheckOutButton extends StatelessWidget {
  const CheckOutButton({super.key, this.onTap, required this.label});

  final void Function()? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          height: 50,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Center(
            child: Text(
              label,
              style: appstyle(20, Colors.white, FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
