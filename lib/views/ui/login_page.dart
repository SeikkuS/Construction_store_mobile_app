import 'package:construction_store_mobile_app/views/ui/mainscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  LoginInPageState createState() => LoginInPageState();
}

class LoginInPageState extends State<LogInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '1099117948271-iupn69f09bhif6i36s2k2mre6sqtr3vl.apps.googleusercontent.com', // Web Client ID
    serverClientId:
        '1099117948271-iupn69f09bhif6i36s2k2mre6sqtr3vl.apps.googleusercontent.com', // Same Web Client ID for Android
  );
  bool _isSigningIn = false; // Tracks sign-in process

  // Sign in with Google
  Future<User?> _signInWithGoogle() async {
    setState(() {
      _isSigningIn = true; // Start loading
    });
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        UserCredential userCredential = await _auth.signInWithPopup(
          googleProvider,
        );
        return userCredential.user;
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null; // User canceled the sign-in
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );
        return userCredential.user;
      }
    } catch (error) {
      print("Error during Google sign-in: $error");
      return null;
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false; // Stop loading
        });
      }
    }
  }

  // Sign in anonymously for guest access
  Future<User?> _signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (error) {
      print("Error during anonymous sign-in: $error");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In"), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "You're not logged in. Sign in with Google to save your favorites and cart across devices.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              _isSigningIn
                  ? const CircularProgressIndicator() // Show loading indicator
                  : ElevatedButton(
                    onPressed: () async {
                      final user = await _signInWithGoogle();
                      if (user != null) {
                        print("Signed in as ${user.displayName}");
                        // Pop the LogInPage to return to the previous page (ProfilePage)
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      } else {
                        print("Google sign-in failed.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.login),
                        SizedBox(width: 10),
                        Text("Sign in with Google"),
                      ],
                    ),
                  ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  final user = await _signInAnonymously();
                  if (user != null) {
                    print("Signed in as guest");
                    // Navigation handled by StreamBuilder in main.dart
                  } else {
                    print("Anonymous sign-in failed.");
                  }
                },
                child: const Text(
                  "Continue without logging in",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
