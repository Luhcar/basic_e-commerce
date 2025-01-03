import 'dart:io';

import 'package:ecommerce/pembeli/cart.dart';
import 'package:ecommerce/database_helper.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailPage({required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

List<Map<String, dynamic>> _products = [];

class _ProductDetailPageState extends State<ProductDetailPage> {
  void initState() {
    super.initState();
    _refreshProducts();
  }

  Future<void> _refreshProducts() async {
    final products = await DatabaseHelper.instance.getProducts();
    setState(() {
      _products = products;
    });
  }

  Future<void> addToCart(Map<String, dynamic> product) async {
    await DatabaseHelper.instance.insertCart({
      'name': product['name']!,
      'price': product['price']!,
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product['imagePath'] != null
                ? Image.file(File(product['imagePath']),
                    height: 300, width: 330, fit: BoxFit.cover)
                : Text('No Image Available'),
            SizedBox(height: 16.0),
            Text('Nama: ${product['name']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Stok: ${product['quantity'] ?? '-'}'),
            SizedBox(height: 8),
            Text('Harga: Rp${product['price']}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Deskripsi: ${product['description'] ?? '-'}'),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                await addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to cart!')),
                );
              },
              child: Text('Add to Cart'),
            )
          ],
        ),
      ),
    );
  }
}
