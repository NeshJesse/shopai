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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShoppingPlans();
  }

  Future<void> _loadShoppingPlans() async {
    setState(() {
      _isLoading = true;
    });
    final response = await _supabase
        .from('shopping_plans')
        .select()
        .order('plan_date', ascending: false);
    setState(() {
      _shoppingPlans = response;
      _isLoading = false;
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

  Widget _buildEmptyState() {
    return Center(
      child: Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_shopping_cart,
                  size: 64, color: Theme.of(context).primaryColor),
              SizedBox(height: 16),
              Text(
                'Create Shopping Plan',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Click the plus button to add a new plan',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'You have not created any plans yet.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanList() {
    return ListView.builder(
      itemCount: _shoppingPlans.length,
      itemBuilder: (context, index) {
        final plan = _shoppingPlans[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ExpansionTile(
            leading: Icon(Icons.calendar_today,
                color: Theme.of(context).primaryColor),
            title: Text(
              'Plan for ${DateFormat('MMMM d, yyyy').format(DateTime.parse(plan['plan_date']))}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Total: \Ksh${plan['total_amount'].toStringAsFixed(2)}',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            children: [
              ...(plan['items'] as List<dynamic>).map((item) => ListTile(
                    leading: Icon(Icons.shopping_bag,
                        color: Theme.of(context).primaryColor),
                    title: Text(item['product'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Brand: ${item['brand']}, Quantity: ${item['qt']}, Supermarket: ${item['supermarket']}',
                    ),
                    trailing: Text(
                      '\KSh${item['price'].toStringAsFixed(2)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Plans'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPlanScreen,
        child: Icon(Icons.add),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _shoppingPlans.isEmpty
              ? _buildEmptyState()
              : _buildPlanList(),
    );
  }
}
