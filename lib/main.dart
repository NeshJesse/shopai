import 'package:flutter/material.dart';
import 'package:shopai/screens/shopping.dart';
import 'package:shopai/screens/features.dart';
import 'package:shopai/baselayout.dart';
import 'package:shopai/screens/splash.dart';
import 'package:shopai/screens/account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://jhfoovgozkmbehzlzbrz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpoZm9vdmdvemttYmVoemx6YnJ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQ4Mzk1MjAsImV4cCI6MjA0MDQxNTUyMH0.wEMpBmDxtipulse43fHHHAHIIt_EA8Up-LM64unDNqE',
  );
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
  String? _username;
  String? _email;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response = await supabase
          .from('users')
          .select('username, email')
          .eq('id', user.id)
          .single();

      setState(() {
        _username = response['username'];
        _email = response['email'];
      });
    }
  }

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
        title: Text('SakaPrice'),
      ),
      child: Center(
        child: ListView(
          children: [
            ListTile(
              leading:
                  Icon(Icons.account_circle, size: 50, color: Colors.white),
              title: Text(_username ?? 'Loading...'),
              subtitle: Text(_email ?? 'Loading...'),
              tileColor: Colors.lightBlueAccent,
              textColor: Colors.white,
            ),
            // Add other widgets here as needed
          ],
        ),
      ),
    );
  }
}
