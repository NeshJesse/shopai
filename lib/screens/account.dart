import 'package:flutter/material.dart';
import 'package:shopai/baselayout.dart';

class UserBioPage extends StatefulWidget {
  @override
  _UserBioPageState createState() => _UserBioPageState();
}

class _UserBioPageState extends State<UserBioPage> {
  String? selectedSupermarket;
  String? selectedLocation;

  final List<String> supermarkets = ['Walmart', 'Target', 'Costco', 'Kroger'];
  final List<String> locations = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix'
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBar: AppBar(
        title: Text('User Bio'),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                onPressed: () {
                  // Here you can implement the logic to save the user's selections
                  print('Selected Supermarket: $selectedSupermarket');
                  print('Selected Location: $selectedLocation');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
