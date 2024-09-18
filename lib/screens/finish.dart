import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class CheckoutQRCodeScreen extends StatefulWidget {
  @override
  _CheckoutQRCodeScreenState createState() => _CheckoutQRCodeScreenState();
}

class _CheckoutQRCodeScreenState extends State<CheckoutQRCodeScreen> {
  final _supabase = Supabase.instance.client;
  String? qrData;
  String? errorMessage;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _generateQRCodeData();
  }

  Future<void> _generateQRCodeData() async {
    try {
      final checkoutResponse = await _supabase
          .from('checkout')
          .select()
          .order('checkout_date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (checkoutResponse == null) {
        throw Exception('No checkout data found');
      }

      final userId = checkoutResponse['user_id'];
      if (userId == null) {
        throw Exception('User ID not found in checkout data');
      }

      final userFuture =
          _supabase.from('users').select().eq('id', userId).maybeSingle();
      final userBioFuture =
          _supabase.from('userbio').select().eq('id', userId).maybeSingle();

      final results = await Future.wait([userFuture, userBioFuture]);
      final userResponse = results[0];
      final userBioResponse = results[1];

      if (userResponse == null) {
        throw Exception('User data not found');
      }

      final qrCodeData = {
        'buyer_name': userResponse['name'] ?? 'Unknown',
        'buyer_phone': userResponse['phone'] ?? 'N/A',
        'total_amount': checkoutResponse['total_amount']?.toString() ?? '0',
        'items': json.decode(checkoutResponse['items'] ?? '[]'),
        'bio': userBioResponse?['bio'] ?? 'N/A',
        'checkout_id': checkoutResponse['id'],
        'user_id': userId,
      };

      setState(() {
        qrData = json.encode(qrCodeData);
        errorMessage = null;
      });
    } catch (e) {
      print('Error generating QR code data: $e');
      setState(() {
        errorMessage = 'Error generating QR code: ${e.toString()}';
      });
    }
  }

  Future<void> _saveToFinishDatabase() async {
    if (qrData == null) {
      setState(() {
        errorMessage = 'No data to save. Please generate QR code first.';
      });
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final dataToSave = json.decode(qrData!);

      // Add a timestamp to the data
      dataToSave['saved_at'] = DateTime.now().toIso8601String();

      final response = await _supabase.from('finish').insert(dataToSave);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data saved successfully!')),
      );
    } catch (e) {
      print('Error saving data: $e');
      setState(() {
        errorMessage = 'Error saving data: ${e.toString()}';
      });
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout QR Code'),
      ),
      body: Center(
        child: errorMessage != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(errorMessage!, style: TextStyle(color: Colors.red)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _generateQRCodeData,
                    child: Text('Retry'),
                  ),
                ],
              )
            : qrData == null
                ? CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QrImageView(
                        data: qrData!,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                      SizedBox(height: 20),
                      Text('Scan this QR code to view checkout details'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isSaving ? null : _saveToFinishDatabase,
                        child: isSaving
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Save '),
                      ),
                    ],
                  ),
      ),
    );
  }
}
