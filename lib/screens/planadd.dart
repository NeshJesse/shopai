import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Planadd extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  Planadd({required this.onSave});

  @override
  _PlanaddState createState() => _PlanaddState();
}

class _PlanaddState extends State<Planadd> {
  final _formKey = GlobalKey<FormState>();
  DateTime _planDate = DateTime.now();
  List<Map<String, dynamic>> _items = [];
  double _totalAmount = 0.0;

  void _addItem() {
    setState(() {
      _items.add({
        'product': '',
        'brand': '',
        'qt': 1,
        'supermarket': '',
        'price': 0.0,
      });
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _calculateTotalAmount();
    });
  }

  void _calculateTotalAmount() {
    _totalAmount = _items.fold(0.0, (sum, item) => sum + (item['price'] ?? 0.0));
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _calculateTotalAmount();
      widget.onSave({
        'plan_date': _planDate.toIso8601String(),
        'total_amount': _totalAmount,
        'items': _items,
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Shopping Plan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Text("Create your Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _planDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (picked != null && picked != _planDate) {
                  setState(() {
                    _planDate = picked;
                  });
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Plan Date',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('yyyy-MM-dd').format(_planDate)),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ..._items.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> item = entry.value;
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text("Item ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeItem(index),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Product'),
                    validator: (value) => value!.isEmpty ? 'Please enter a product name' : null,
                    onSaved: (value) => item['product'] = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Brand'),
                    onSaved: (value) => item['brand'] = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Please enter a quantity' : null,
                    onSaved: (value) => item['qt'] = int.parse(value!),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Supermarket'),
                    onSaved: (value) => item['supermarket'] = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
                    onSaved: (value) {
                      item['price'] = double.parse(value!);
                      _calculateTotalAmount();
                    },
                  ),
                  SizedBox(height: 20),
                ],
              );
            }).toList(),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Add Item'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Save Plan'),
            ),
          ],
        ),
      ),
    );
  }
}

