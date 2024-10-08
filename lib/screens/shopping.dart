import 'package:flutter/material.dart';
import 'package:shopai/baselayout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'additem.dart';

import 'package:shopai/screens/checks.dart';
import 'package:shopai/screens/lists.dart';

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
      final user = _supabase.auth.currentUser;

      if (user != null) {
        newItem['user_id'] = user.id;
        await _supabase.from('shoplist').insert(newItem);
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
      // Get the current user
      final user = _supabase.auth.currentUser;

      if (user == null) {
        throw Exception('User is not authenticated');
      }

      // Calculate total amount
      double totalAmount =
          _shoppingList.fold(0, (sum, item) => sum + (item['price'] ?? 0));

      // Prepare checkout data
      Map<String, dynamic> checkoutData = {
        'checkout_date': DateTime.now().toIso8601String(),
        'total_amount': totalAmount,
        'items': json.encode(_shoppingList),
        'user_id': user.id, // Add the user_id to the checkout data
      };

      // Insert into checkout database
      await _supabase.from('checkout').insert(checkoutData);

      // Clear the shopping list
      await _supabase.from('shoplist').delete().eq('user_id', user.id);

      // Refresh checkout history and shopping list
      await _loadCheckoutHistory();
      await _loadShoppingList();

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
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: EdgeInsets.all(10.0),
                    color: Colors.black,
                    child: ListTile(
                      leading:
                          Icon(Icons.list_alt_outlined, color: Colors.white),
                      title: Text(
                        'Current Shopping Lists',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        // Navigate to listScreen when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ListScreen(shoppingLists: _shoppingList),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: EdgeInsets.all(10.0),
                    color: Colors.black,
                    child: ListTile(
                      leading:
                          Icon(Icons.history_outlined, color: Colors.white),
                      title: Text(
                        'Checkout History',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        // Navigate to checks.dart when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChecksPage(checkoutHistory: _checkoutHistory),
                          ),
                        );
                      },
                    ),
                  ),
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
