import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    print("User signed out");
    debugPrint("User signed out");
    // Optionally, navigate back to the login or home page after signing out
    Navigator.pop(context); // Or navigate to login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: GestureDetector(
          onTap: () async {
            await signOut();
          },
          child: Icon(Icons.logout, size: 50, color: Colors.grey),
        ),
      ),
    );
  }
}
