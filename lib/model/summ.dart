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
      leading: Icon(Icons.star), // Bell icon
      title: Text(
        ' $title',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        children: [
          Text(
            '    $subtitle',
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Verified',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
      selectedTileColor: Colors.black,
      splashColor: Colors.blueAccent,
    );
  }
}
