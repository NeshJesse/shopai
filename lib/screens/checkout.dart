import 'package:flutter/material.dart';
import 'dart:convert';

class CheckoutDetailScreen extends StatelessWidget {
  final Map<String, dynamic> checkoutData;

  CheckoutDetailScreen({required this.checkoutData});

  @override
  Widget build(BuildContext context) {
    // Decode the items from JSON
    List<dynamic> items = json.decode(checkoutData['items']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Checkout Date: ${DateTime.parse(checkoutData['checkout_date']).toLocal()}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Total Amount: \$${checkoutData['total_amount'].toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item['product']),
                    subtitle: Text(
                        'Brand: ${item['brand']}, Quantity: ${item['qt']}, Supermarket: ${item['supermarket']}'),
                    trailing: Text('\$${item['price']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
