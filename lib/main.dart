import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:construction_store_mobile_app/controllers/cart_provider.dart';
import 'package:construction_store_mobile_app/controllers/favorites_notifier.dart';
import 'package:construction_store_mobile_app/controllers/mainscreen_provider.dart';
import 'package:construction_store_mobile_app/controllers/product_provider.dart';
import 'package:construction_store_mobile_app/views/ui/mainscreen.dart';
import 'package:construction_store_mobile_app/views/ui/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            // Defer setting userId until after the build phase
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final favoritesNotifier = Provider.of<FavoritesNotifier>(
                context,
                listen: false,
              );
              final cartProvider = Provider.of<CartProvider>(
                context,
                listen: false,
              );
              favoritesNotifier.setUserId(user.uid);
              cartProvider.setUserId(user.uid);
            });
            return MainScreen();
          } else {
            return LogInPage();
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
