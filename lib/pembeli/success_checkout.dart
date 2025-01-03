import 'package:ecommerce/database_helper.dart';
import 'package:ecommerce/pembeli/product_detail.dart';
import 'package:ecommerce/pembeli/product_list.dart';
import 'package:flutter/material.dart';

class CheckoutSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Success'),
      ),
      body: Center(
        child: Text(
          'Checkout berhasil!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
       bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            await DatabaseHelper.instance.deleteAllCart();
            // Navigasikan ke halaman berhasil checkout
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductListPage()),
            );
          },
          child: Text('Kembali ke halaman utama'),
        ),
      ),
    );
  }
}
