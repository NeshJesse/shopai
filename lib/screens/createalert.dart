import 'package:flutter/material.dart';

class Planadd extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  Planadd({required this.onSave});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<Planadd> {
  final _formKey = GlobalKey<FormState>();
  String _product = '';
  String _brand = '';
  int _quantity = 0;
  String _supermarket = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSave({
        'product': _product,
        'brand': _brand,
        'qt': _quantity,
        'supermarket': _supermarket,
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Item')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Text("Create your Plan"),
            TextFormField(
              decoration: InputDecoration(labelText: 'Product'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a product name' : null,
              onSaved: (value) => _product = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Brand'),
              onSaved: (value) => _brand = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a quantity' : null,
              onSaved: (value) => _quantity = int.parse(value!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Supermarket'),
              onSaved: (value) => _supermarket = value!,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
