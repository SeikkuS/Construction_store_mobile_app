import 'package:construction_store_mobile_app/views/shared/appstyle.dart';
import 'package:flutter/material.dart';
import 'package:construction_store_mobile_app/controllers/favorites_notifier.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
    final favoritesNotifier = Provider.of<FavoritesNotifier>(
      context,
      listen: false,
    );
    favoritesNotifier.getFavorites(); // Fetch favorites from Firestore
  }

  @override
  Widget build(BuildContext context) {
    var favoritesNotifier = Provider.of<FavoritesNotifier>(context);
    final favorites = favoritesNotifier.favorites;

    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                  child: const Icon(Ionicons.close, color: Colors.black),
                ),
                Text(
                  "My Favorites",
                  style: appstyle(36, Colors.black, FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: ListView.builder(
                    itemCount: favorites.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final product = favorites[index];
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  spreadRadius: 5,
                                  blurRadius: 0.3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Product Image
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Image.asset(
                                    product['image'] ??
                                        'assets/images/placeholder.png',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/placeholder.png',
                                      );
                                    },
                                  ),
                                ),
                                // Product Details
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      left: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'] ?? 'Unknown Product',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: appstyle(
                                            16,
                                            Colors.black,
                                            FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          product['category'] ??
                                              'Unknown Category',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: appstyle(
                                            14,
                                            Colors.grey,
                                            FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "${product['price'] ?? 'N/A'}",
                                          style: appstyle(
                                            18,
                                            Colors.black,
                                            FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                                // Heart Icon
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Ionicons.heart,
                                      color: Colors.black,
                                    ),
                                    onPressed: () async {
                                      await favoritesNotifier.deleteFav(
                                        product['key'],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
