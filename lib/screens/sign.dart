import 'package:flutter/material.dart';
import 'package:shopai/main.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithGoogle() async {
    try {
      final response = await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.yourdomain.yourapp://login-callback/',
        authScreenLaunchMode: LaunchMode.inAppWebView,
      );

      if (response) {
        // Get user data
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          // Add user to the database
          await Supabase.instance.client.from('users').upsert({
            'id': user.id,
            'email': user.email,
            'username': user.userMetadata?['full_name'] ?? '',
            // Add any other user data you want to store
          });

          // Navigate to main page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in with Google: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
                // Implement email/password signup logic here
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(
                    decorationColor: Colors.black,
                    color: Colors.black,
                    fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.white,
              ),
              child: Text('Sign Up'),
            ),
            SizedBox(height: 20),
            SignInButton(
              Buttons.google,
              text: "Sign in with Google",
              onPressed: _signInWithGoogle,
            ),
          ],
        ),
      ),
    );
  }
}
