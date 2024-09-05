import 'package:flutter/material.dart';
import 'package:shopai/baselayout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'additem.dart';

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<Map<String, dynamic>> _shoppingList = [];
  List<Map<String, dynamic>> _checkoutHistory = [];
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
    _loadCheckoutHistory();
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

  Future<void> _loadCheckoutHistory() async {
    final response = await _supabase
        .from('checkout')
        .select()
        .order('checkout_date', ascending: false);
    setState(() {
      _checkoutHistory = response;
    });
  }

  Future<void> _addItem(Map<String, dynamic> newItem) async {
    try {
      await _supabase.from('shoplist').insert(newItem);
      await _loadShoppingList();
    } catch (e) {
      print('Error adding item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding item. Please try again.')),
      );
    }
  }

  Future<void> _checkout() async {
    if (_shoppingList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your shopping list is empty.')),
      );
      return;
    }

    try {
      // Calculate total amount
      double totalAmount =
          _shoppingList.fold(0, (sum, item) => sum + (item['price'] ?? 0));

      // Prepare checkout data
      Map<String, dynamic> checkoutData = {
        'checkout_date': DateTime.now().toIso8601String(),
        'total_amount': totalAmount,
        'items': json.encode(_shoppingList),
      };

      // Insert into checkout database
      await _supabase.from('checkout').insert(checkoutData);

      // Refresh checkout history
      await _loadCheckoutHistory();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout successful!')),
      );
    } catch (e) {
      print('Error during checkout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during checkout. Please try again.')),
      );
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
      children: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                if (_checkoutHistory.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Checkout History',
                    ),
                  ),
                  ..._checkoutHistory.map((checkout) => ListTile(
                        leading: Icon(Icons.receipt),
                        title: Text(
                            'Checkout on ${DateTime.parse(checkout['checkout_date']).toLocal()}'),
                        subtitle: Text(
                            'Total: \$${checkout['total_amount'].toStringAsFixed(2)}'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // TODO: Navigate to a detailed view of this checkout
                        },
                      )),
                  Divider(),
                ],
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: EdgeInsets.all(10.0),
                    color: Colors.black,
                    child: ListTile(
                      leading: Icon(
                        Icons.list_alt_outlined,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Current Shopping List',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Click the plus button to create one',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                ..._shoppingList.map((item) => ListTile(
                      leading: Icon(Icons.shopping_bag),
                      title: Text(item['product']),
                      subtitle: Text(
                          'Brand: ${item['brand']}, Quantity: ${item['qt']}, Supermarket: ${item['supermarket']}'),
                      trailing: Text('\$${item['price']}'),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _checkout,
              child: Text('Checkout'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
