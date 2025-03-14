import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:construction_store_mobile_app/views/ui/login_page.dart';
import 'package:construction_store_mobile_app/views/ui/packages_page.dart'; // Add this

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    print("User signed out");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have been logged out.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;

        if (user == null || user.isAnonymous) {
          return Scaffold(
            appBar: AppBar(title: const Text("Profile")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "You are not logged in. Log in now to access your profile.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogInPage(),
                        ),
                      );
                    },
                    child: const Text("Log In"),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, size: 30),
                onPressed: signOut,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.photoURL ?? ''),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(user.displayName ?? 'No name'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: Text(user.email ?? 'No email'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(
                          "Member since: ${user.metadata.creationTime?.toString().split(' ')[0] ?? 'Unknown'}",
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.shopping_bag),
                        title: const Text("Your Packages"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PackagesPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
