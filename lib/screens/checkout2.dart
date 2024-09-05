import 'package:flutter/material.dart';

class CheckoutDetailScreen extends StatelessWidget {
  final Map<String, dynamic> checkoutData;

  const CheckoutDetailScreen({Key? key, required this.checkoutData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                'Date: ${DateTime.parse(checkoutData['checkout_date']).toLocal()}'),
            SizedBox(height: 10),
            Text(
                'Total Amount: \$${checkoutData['total_amount'].toStringAsFixed(2)}'),
            // Add more details as needed...
          ],
        ),
      ),
    );
  }
}
