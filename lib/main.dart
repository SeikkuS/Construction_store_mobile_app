import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shope_collection_app/controllers/cart_provider.dart';
import 'package:shope_collection_app/controllers/favorites_notifier.dart';
import 'package:shope_collection_app/controllers/mainscreen_provider.dart';
import 'package:shope_collection_app/controllers/product_provider.dart';
import 'package:shope_collection_app/views/ui/mainscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();

  Hive.init(dir.path);

  await Future.wait([Hive.openBox('cart_box'), Hive.openBox('fav_box')]);

  // IF YOU WANT TO CLEAR THE CART OR FAVORITES ON EVERY STARTUP OF THE APP (FOR TESTING),
  // SIMPLY UNDO COMMENTS BELOW
  // var _cartBox = await Hive.openBox('cart_box');
  // await _cartBox.clear();
  // var _favBox = await Hive.openBox('fav_box');
  // await _favBox.clear();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainScreenNotifier()),
        ChangeNotifierProvider(create: (context) => ProductNotifier()),
        ChangeNotifierProvider(create: (context) => FavoritesNotifier()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Tavaraperkele',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: MainScreen(),
        );
      },
    );
  }
}
