import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:construction_store_mobile_app/controllers/mainscreen_provider.dart';
import 'package:construction_store_mobile_app/views/shared/bottom_nav.dart';
import 'package:construction_store_mobile_app/views/ui/cartpage.dart';
import 'package:construction_store_mobile_app/views/ui/favoritespage.dart';
import 'package:construction_store_mobile_app/views/ui/homepage.dart';
import 'package:construction_store_mobile_app/views/ui/profile.dart';
import 'package:construction_store_mobile_app/views/ui/searchpage.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<Widget> pageList = [
    const HomePage(),
    const SearchPage(),
    const Favorites(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
      builder: (context, mainScreenNotifier, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFE2E2E2),
          body: pageList[mainScreenNotifier.pageIndex],

          bottomNavigationBar: const BottomNavBar(),
        );
      },
    );
  }
}
