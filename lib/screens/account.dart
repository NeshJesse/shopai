import 'package:flutter/material.dart';
import 'package:shopai/baselayout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shopai/screens/userbiocard.dart';
import 'package:shopai/main.dart';

class UserBioPage extends StatefulWidget {
  @override
  _UserBioPageState createState() => _UserBioPageState();
}

class _UserBioPageState extends State<UserBioPage> {
  String? selectedSupermarket;
  String? selectedLocation;
  final TextEditingController _phoneController = TextEditingController();

  final List<String> supermarkets = ['Naivas', 'Quickmart', 'Chandarana'];
  final List<String> locations = [
    'Nairobi',
    'Kiambu',
    'Nakuru',
    'Kisumu',
    'Mombasa'
  ];

  Future<void> _saveUserBio() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client.from('userbio').insert({
          'id': user.id, // Associate the data with the current user
          'phone': _phoneController.text.trim(),
          'pref_super': selectedSupermarket,
          'location': selectedLocation,
        });

        // Show a green SnackBar for success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User bio saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the main page after a brief delay
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(
              context, '/home'); // Adjust the route name as needed
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not authenticated!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving user bio: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBar: AppBar(
        title: Text('User Bio'),
      ),
      children: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserBioCard(),
              Text(
                'Phone Number:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Preferred Supermarket:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Column(
                children: supermarkets.map((String supermarket) {
                  return RadioListTile<String>(
                    title: Text(supermarket),
                    value: supermarket,
                    groupValue: selectedSupermarket,
                    onChanged: (String? value) {
                      setState(() {
                        selectedSupermarket = value;
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text(
                'Location:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedLocation,
                hint: Text('Select a location'),
                isExpanded: true,
                items: locations.map((String location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLocation = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Save'),
                onPressed: _saveUserBio,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
