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
  late final GoogleSignIn _googleSignIn;

  bool _isSigningIn = false;

  @override
  void initState() {
    super.initState();
    // Initialize GoogleSignIn based on platform
    _googleSignIn = GoogleSignIn(
      clientId:
          kIsWeb
              ? '1099117948271-iupn69f09bhif6i36s2k2mre6sqtr3vl.apps.googleusercontent.com'
              : null, // Web uses clientId only
      serverClientId:
          kIsWeb
              ? null
              : '1099117948271-iupn69f09bhif6i36s2k2mre6sqtr3vl.apps.googleusercontent.com', // Mobile uses serverClientId
    );
  }

  Future<User?> _signInWithGoogle() async {
    setState(() {
      _isSigningIn = true;
    });
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        UserCredential userCredential = await _auth.signInWithPopup(
          googleProvider,
        );
        debugPrint("Web sign-in success: ${userCredential.user?.displayName}");
        return userCredential.user;
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          debugPrint("Google sign-in canceled by user");
          return null;
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );
        debugPrint(
          "Mobile sign-in success: ${userCredential.user?.displayName}",
        );
        return userCredential.user;
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign-in failed: ${error.toString()}")),
        );
      }
      debugPrint("Error during Google sign-in: $error");
      return null;
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  Future<User?> _signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      debugPrint("Signed in anonymously: ${userCredential.user?.uid}");
      return userCredential.user;
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Anonymous sign-in failed: $error")),
        );
      }
      debugPrint("Error during anonymous sign-in: $error");
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
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: () async {
                      await _signInWithGoogle();
                      // Navigation is handled by StreamBuilder in AuthWrapper,
                      // so we do NOT call Navigator.pop(context) here
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
                  await _signInAnonymously();
                  // Navigation handled by StreamBuilder in main.dart
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
