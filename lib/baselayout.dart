import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BaseLayout extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget children;
  final Widget? floatingActionButton;

  BaseLayout(
      {this.appBar,
      this.body,
      required this.children,
      this.floatingActionButton});

  @override
  _BaseLayoutState createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  String _username = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client
            .from('users')
            .select('username, email')
            .eq('id', user.id)
            .single();

        setState(() {
          _username = response['username'] ?? 'Unknown';
          _email = response['email'] ?? 'Unknown';
        });
      }
    } catch (error) {
      // Handle the error appropriately in a real app
      print('Error fetching user data: $error');
    }
  }

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
              accountName: Text(_username),
              accountEmail: Text(_email),
            ),
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
      appBar: widget.appBar,
      body: widget.children,
      floatingActionButton: widget.floatingActionButton,
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
