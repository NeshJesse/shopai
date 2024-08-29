import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserBioCard extends StatefulWidget {
  @override
  _UserBioCardState createState() => _UserBioCardState();
}

class _UserBioCardState extends State<UserBioCard> {
  Map<String, dynamic>? userBioData;

  @override
  void initState() {
    super.initState();
    _fetchUserBio();
  }

  Future<void> _fetchUserBio() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client
            .from('userbio')
            .select()
            .eq('id', user.id)
            .single();

        setState(() {
          userBioData = response;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user bio: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: userBioData != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phone Number: ${userBioData!['phone']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Preferred Supermarket: ${userBioData!['pref_super']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Location: ${userBioData!['location']}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              )
            : Center(
                child:
                    CircularProgressIndicator()), // Show a loading indicator while fetching data
      ),
    );
  }
}
