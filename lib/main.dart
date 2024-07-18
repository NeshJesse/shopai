// main.dart
import 'package:flutter/material.dart';
import 'package:shopai/screens/shopping.dart';
import 'package:shopai/screens/features.dart'; // Make sure to import your HomeScreen here
import 'package:shopai/baselayout.dart';
import 'package:shopai/screens/splash.dart';
import 'package:shopai/screens/account.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
      routes: {
        '/home': (context) => MainPage(),
        '/feature': (context) => FeatureUpvotePage(),
        '/shop': (context) => ShoppingListScreen(),
        '/account': (context) => UserBioPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    ShoppingListScreen(),
    FeatureUpvotePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/shop');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/feature');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/account');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBar: AppBar(
        title: Text('Shopping List Page'),
      ),
      child: Text('Main Page Content'),
    );
  }
}
