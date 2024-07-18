import 'package:flutter/material.dart';
import 'package:shopai/baselayout.dart';
import 'add.dart';

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<Map<String, dynamic>> _shoppingList = [];

  void _addItem(Map<String, dynamic> newItem) {
    setState(() {
      _shoppingList.add(newItem);
    });
  }

  void _showAddItemScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddItemScreen(
          onSave: _addItem,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBar: AppBar(
        title: Text('Saka Price'),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              margin: EdgeInsets.all(10.0),
              child: ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Snap the Picture'),
                onTap: () {
                  // Add your onTap functionality here
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _shoppingList.length,
              itemBuilder: (context, index) {
                final item = _shoppingList[index];
                return ListTile(
                  title: Text(item['productName']),
                  subtitle: Text(
                      'Brand: ${item['brand']}, Quantity: ${item['quantity']}'),
                  trailing: Text('Price: \$${item['price']}'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemScreen,
        child: Icon(Icons.add),
      ),
    );
  }
}
