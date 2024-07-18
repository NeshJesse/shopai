import 'package:flutter/material.dart';
import 'package:shopai/main.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              onPressed: () {
                // Implement your Google Sign-In logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
