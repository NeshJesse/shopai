import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopai/screens/shopping.dart';
import 'package:shopai/screens/features.dart';
import 'package:shopai/baselayout.dart';
import 'package:shopai/screens/splash.dart';
import 'package:shopai/screens/account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shopai/screens/planlist.dart';
import 'package:shopai/screens/alerts.dart';

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
      children: Center(
        child: Column(
          children: [
            Text(
              "Utilities",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
            ),

            Card(
              margin: EdgeInsets.all(10.0),
              color: Colors.black,
              child: ListTile(
                leading: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  'Shopping Budget Planner',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'See the prices of your monthly items',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 240, 232, 232),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_circle_right_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlanListScreen()),
                    );
                  },
                  color: Colors.white,
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(10.0),
              color: const Color.fromARGB(255, 36, 30, 30),
              child: ListTile(
                leading: Icon(
                  Icons.notification_important_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  'Set Notifications',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Set notifications for product deal alerts',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 240, 232, 232),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_circle_right_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AlertsScreen()),
                    );
                  },
                  color: Colors.white,
                ),
              ),
            ), // // Add other widgets here as needed
          ],
        ),
      ),
    );
  }
}
