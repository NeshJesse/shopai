import 'package:flutter/material.dart';
import 'package:shopai/baselayout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'additem.dart';
import 'package:shopai/screens/checkout.dart';

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

  /*
  Future<void> _addItem(Map<String, dynamic> newItem) async {
    try {
      // Get the current user's ID
    final user = _supabase.auth.currentUser;
      await _supabase.from('shoplist').insert(newItem);
      await _loadShoppingList();
    } catch (e) {
      print('Error adding item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding item. Please try again.')),
      );
    }
  }
   */
  Future<void> _addItem(Map<String, dynamic> newItem) async {
    try {
      // Get the current user's ID
      final user = _supabase.auth.currentUser;

      if (user != null) {
        // Add user_id to the new item data
        newItem['user_id'] = user.id;

        // Insert the new item with the user_id into the shoplist table
        await _supabase.from('shoplist').insert(newItem);

        // Reload the shopping list after insertion
        await _loadShoppingList();
      } else {
        throw Exception('User is not authenticated');
      }
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
        title: Text('QuickShopa'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemScreen,
        child: Icon(Icons.add),
      ),
      children: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              margin: EdgeInsets.all(10.0),
              color: Colors.black,
              child: ListTile(
                leading: Icon(Icons.start_outlined),
                textColor: Colors.white,
                title: Text('Click the plus button to create a new list'),
              ),
            ),
          ),
          Expanded(
            child: ListView(children: [
              ExpansionTile(
                leading: Icon(
                  Icons.list_alt_outlined,
                  color: Colors.black,
                ),
                initiallyExpanded: true,
                title: Text(
                  'Current Shopping Lists',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                children: [
                  ..._shoppingList.map(
                    (item) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          margin: EdgeInsets.all(10.0),
                          color: Colors.black,
                          child: ListTile(
                            leading:
                                Icon(Icons.shopping_bag, color: Colors.white),
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
                          )),
                    ),
                  ),
                ],
              ),
            ]),
          ),
          Expanded(
            child: ListView(
              children: [
                ExpansionTile(
                  leading: Icon(
                    Icons.history_outlined,
                    color: Colors.black,
                  ),
                  title: Text('Checkout History'),
                  children: [
                    if (_checkoutHistory.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Checkout History',
                        ),
                      ),
                      ..._checkoutHistory.map(
                        (checkout) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            margin: EdgeInsets.all(10.0),
                            color: Colors.black,
                            child: ListTile(
                              leading: Icon(Icons.receipt),
                              title: Text(
                                'Checkout on ${DateTime.parse(checkout['checkout_date']).toLocal()}',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Total: \$${checkout['total_amount'].toStringAsFixed(2)}',
                                style: TextStyle(color: Colors.white),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              tileColor: Colors.black,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutDetailScreen(
                                      checkoutData: checkout,
                                    ),
                                  ),
                                );
                                // TODO: Navigate to a detailed view of this checkout
                              },
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ],
                ),
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
