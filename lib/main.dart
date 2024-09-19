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
    // Get screen width to determine responsiveness
    var screenWidth = MediaQuery.of(context).size.width;

    // Adjust the number of columns based on the screen width
    int crossAxisCount = screenWidth < 600 ? 1 : 2;

    return BaseLayout(
      appBar: AppBar(
        elevation: 5.0,
        title: Text(
          'QuickShopa',
          style: TextStyle(
            fontFamily: 'Montserrat', // Replace with your preferred font
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.deepPurpleAccent,
                Colors.purpleAccent,
              ],
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // Opens the drawer inherited from BaseLayout
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Add search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Add notification functionality
            },
          ),
        ],
        shadowColor: Colors.black.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      children: Center(
        child: GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                crossAxisCount, // Adjust columns based on screen size
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1.5, // Adjust based on card size
          ),
          itemCount: 3, // Number of cards you have
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildCard(
                context,
                'Quick Shopping',
                'Enter your shopping list & shop',
                Icons.shopping_cart_outlined,
                Colors.purpleAccent,
                ShoppingListScreen(),
              );
            } else if (index == 1) {
              return _buildCard(
                context,
                'Shopping Budget Planner',
                'See the prices of your monthly items',
                Icons.calendar_month_rounded,
                Colors.black,
                PlanListScreen(),
              );
            } else if (index == 2) {
              return _buildCard(
                context,
                'Set Notifications',
                'Set notifications for product deal alerts',
                Icons.notification_important_outlined,
                const Color.fromARGB(255, 36, 30, 30),
                AlertsScreen(),
              );
            }
            return Container(); // Placeholder for additional cards
          },
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    Widget destination,
  ) {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(height: 6.0),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Explore',
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
