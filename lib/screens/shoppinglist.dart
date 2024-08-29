import 'package:flutter/material.dart';
import 'package:shopai/baselayout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'additem.dart';

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<Map<String, dynamic>> _shoppingList = [];
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
  }

  Future<void> _loadShoppingList() async {
    final response = await _supabase
        .from('shoplist')
        .select()
        .order('created_at', ascending: false);
    setState(() {
      _shoppingList = response;
    });
  }

  Future<void> _addItem(Map<String, dynamic> newItem) async {
    try {
      await _supabase.from('shoplist').insert(newItem);
      await _loadShoppingList();
    } catch (e) {
      print('Error adding item: $e');
      // You might want to show an error message to the user here
    }
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemScreen,
        child: Icon(Icons.add),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _shoppingList.length,
              itemBuilder: (context, index) {
                final item = _shoppingList[index];
                return ListTile(
                  leading: Icon(Icons.shopping_bag),
                  title: Text(item['product']),
                  subtitle: Text(
                      'Brand: ${item['brand']}, Quantity: ${item['qt']}, Supermarket: ${item['supermarket']}'),
                  // You might want to add a price field to your database if it's relevant
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
