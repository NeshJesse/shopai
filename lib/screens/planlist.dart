import 'package:flutter/material.dart';
import 'package:shopai/baselayout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'planadd.dart';

class PlanListScreen extends StatefulWidget {
  @override
  _PlanListScreenState createState() => _PlanListScreenState();
}

class _PlanListScreenState extends State<PlanListScreen> {
  List<Map<String, dynamic>> _shoppingPlans = [];
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadShoppingPlans();
  }

  Future<void> _loadShoppingPlans() async {
    final response = await _supabase
        .from('shopping_plans')
        .select()
        .order('plan_date', ascending: false);
    setState(() {
      _shoppingPlans = response;
    });
  }

  Future<void> _addPlan(Map<String, dynamic> newPlan) async {
    try {
      await _supabase.from('shopping_plans').insert({
        'user_id': _supabase.auth.currentUser!.id,
        'plan_date': newPlan['plan_date'],
        'total_amount': newPlan['total_amount'],
        'items': newPlan['items'],
      });
      await _loadShoppingPlans();
    } catch (e) {
      print('Error adding plan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding plan. Please try again.')),
      );
    }
  }

  void _showAddPlanScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Planadd(
          onSave: _addPlan,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saka Price - Shopping Plans'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPlanScreen,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _shoppingPlans.length,
        itemBuilder: (context, index) {
          final plan = _shoppingPlans[index];
          return ExpansionTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
                'Plan for ${DateFormat('yyyy-MM-dd').format(DateTime.parse(plan['plan_date']))}'),
            subtitle:
                Text('Total: \$${plan['total_amount'].toStringAsFixed(2)}'),
            children: [
              ...(plan['items'] as List<dynamic>).map((item) => ListTile(
                    leading: Icon(Icons.shopping_bag),
                    title: Text(item['product']),
                    subtitle: Text(
                        'Brand: ${item['brand']}, Quantity: ${item['qt']}, Supermarket: ${item['supermarket']}'),
                    trailing: Text('\$${item['price']}'),
                  )),
            ],
          );
        },
      ),
    );
  }
}
