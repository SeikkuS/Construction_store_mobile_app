import 'package:construction_store_mobile_app/controllers/favorites_notifier.dart';
import 'package:construction_store_mobile_app/views/ui/cartpage.dart';
import 'package:construction_store_mobile_app/views/ui/favoritespage.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:construction_store_mobile_app/controllers/mainscreen_provider.dart';
import 'package:construction_store_mobile_app/views/shared/bottom_nav_widget.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
      builder: (context, mainScreenNotifier, child) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BottomNavWidget(
                    onTap: () {
                      mainScreenNotifier.pageIndex = 0;
                    },
                    icon:
                        mainScreenNotifier.pageIndex == 0
                            ? Ionicons.home
                            : Ionicons.home_outline,
                  ),
                  BottomNavWidget(
                    onTap: () {
                      mainScreenNotifier.pageIndex = 1;
                    },
                    icon:
                        mainScreenNotifier.pageIndex == 1
                            ? Ionicons.search
                            : Ionicons.search,
                  ),
                  BottomNavWidget(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Favorites(),
                        ),
                      );
                    },
                    icon:
                        Provider.of<FavoritesNotifier>(
                              context,
                            ).favorites.isNotEmpty
                            ? Ionicons.heart
                            : Ionicons.heart_outline,
                  ),

                  BottomNavWidget(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },
                    icon: Ionicons.cart_outline,
                  ),
                  BottomNavWidget(
                    onTap: () {
                      mainScreenNotifier.pageIndex = 4;
                    },
                    icon:
                        mainScreenNotifier.pageIndex == 4
                            ? Ionicons.person
                            : Ionicons.person_outline,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
