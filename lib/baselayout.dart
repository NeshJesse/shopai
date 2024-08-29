// baselayout.dart
import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget child;
  final Widget? floatingActionButton;

  BaseLayout(
      {this.appBar, this.body, required this.child, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        elevation: 0,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/monlo.png"),
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
      appBar: appBar,
      body: child,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
        ],
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.black,
        // Implement navigation logic in the parent widget to control navigation
        onTap: (index) {
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
        },
      ),
    );
  }
}
