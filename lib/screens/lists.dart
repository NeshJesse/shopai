import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> shoppingLists;

  const ListScreen({Key? key, required this.shoppingLists}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Lists'),
      ),
      body: ListView.builder(
        itemCount: shoppingLists.length,
        itemBuilder: (context, index) {
          final item = shoppingLists[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              margin: EdgeInsets.all(10.0),
              color: Colors.black,
              child: ListTile(
                leading: Icon(Icons.shopping_bag, color: Colors.white),
                title: Text(
                  item['product'],
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Brand: ${item['brand']}, Quantity: ${item['qt']}, Supermarket: ${item['supermarket']}',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  '\$${item['price']}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
