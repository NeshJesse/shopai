import 'package:flutter/material.dart';

class NewsBox extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String buttonText1;
  final String buttonText2;

  const NewsBox({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.buttonText1,
    required this.buttonText2,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: Colors.amber,
      leading: Icon(Icons.location_city_rounded), // Bell icon
      title: Text(
        ' $title',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(' $subtitle'),
      trailing: ElevatedButton(
        onPressed: () {},
        child: Icon(Icons.share),
      ),
      onTap: () {
        // Handle tap on notification item
        // You can navigate to a detailed view or perform other actions here
      },
    );
  }
}
