import 'package:flutter/material.dart';
import 'package:shopai/screens/shoplist.dart';
import 'package:shopai/screens/features.dart';
import 'package:shopai/screens/askscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      routes: {
        '/home': (context) => MainPage(),
        '/alerts': (context) => AlertsScreen(),
        '/account': (context) => AccountScreen(),
        '/feature': (context) => FeatureUpvotePage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/home');
          break;
        case 1:
          Navigator.pushNamed(context, '/shop');
          break;
        case 2:
          _showAddTaskDialog(context);
          break;
        case 3:
          _snapShoppingList();
          break;
      }
    });
  }

  void _showAddTaskDialog(BuildContext context) {
    // Implement your add task dialog here
  }

  void _snapShoppingList() {
    // Implement your snap shopping list functionality here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      drawer: Drawer(
        elevation: 0,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/plp.jpeg"),
              ),
              accountName: Text("Nehemiah"),
              accountEmail: Text("neshjesse@gmail.com"),
            ),
            // Drawer menu items for different task categories
            ListTile(
              title: Text("Home"),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              title: Text("Feature Vote"),
              leading: Icon(Icons.thumb_up_sharp),
              onTap: () {
                Navigator.pushNamed(context, '/feature');
              },
            ),
            ListTile(
              title: Text("Account"),
              leading: Icon(Icons.account_circle),
              onTap: () {
                Navigator.pushNamed(context, '/account');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Main Page Content'), // Replace this with your main content
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shopping Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Snap List',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
      backgroundColor: Colors.lightBlue,
    );
  }
}

class AlertsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alerts Screen'),
      ),
      body: Center(
        child: Text('Alerts Screen Content'),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Screen'),
      ),
      body: Center(
        child: Text('Account Screen Content'),
      ),
    );
  }
}
