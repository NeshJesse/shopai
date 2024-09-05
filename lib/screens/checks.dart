import 'package:flutter/material.dart';
import 'package:shopai/screens/checkout2.dart';

class ChecksPage extends StatelessWidget {
  final List<Map<String, dynamic>> checkoutHistory;

  const ChecksPage({Key? key, required this.checkoutHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout History'),
      ),
      body: checkoutHistory.isNotEmpty
          ? ListView.builder(
              itemCount: checkoutHistory.length,
              itemBuilder: (context, index) {
                final checkout = checkoutHistory[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: EdgeInsets.all(10.0),
                    color: Colors.black,
                    child: ListTile(
                      leading: Icon(Icons.receipt, color: Colors.white),
                      title: Text(
                        'Checkout on ${DateTime.parse(checkout['checkout_date']).toLocal()}',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Total: \$${checkout['total_amount'].toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: Colors.white),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CheckoutDetailScreen(
                              checkoutData: checkout,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text('No checkout history available',
                  style: TextStyle(color: Colors.white)),
            ),
    );
  }
}
