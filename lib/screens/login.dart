import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shopai/main.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Login({Key? key}) : super(key: key);

  Future<void> _login(BuildContext context) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    try {
      // Attempt to sign in with email and password
      final AuthResponse response =
          await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final User? user = response.user;

      if (user != null) {
        // If the login is successful, navigate to the main page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        // If there's an issue, display an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Login failed. Please check your credentials.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _login(context),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
