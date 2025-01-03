import 'dart:io';
import 'package:ecommerce/pembeli/cart.dart';
import 'package:ecommerce/database_helper.dart';
import 'package:ecommerce/filter_sorting.dart';
import 'package:ecommerce/pembeli/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Map<String, dynamic>>> _productList;

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  void _refreshProducts() {
    setState(() {
      _productList = DatabaseHelper.instance.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Belanja'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartPage()))
                .then((_) => _refreshProducts()),
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada produk'));
          }

          final products = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailPage(product: product),
                  ),
                ),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                                image: FileImage(File(product['imagePath'])),
                                fit: BoxFit.cover,
                                height: 150,
                                width: 150),
                            SizedBox(height: 10.0),
                            Text(
                              product['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Rp. ${product['price']}'),
                          ],
                        ),
                      ),
                    ], 
                  ),
                ),
              );
            },
          );
        },
      ),
       bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            // Navigasikan ke halaman berhasil checkout
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FilterSortingPage()),
            );
          },
          child: Text('filter & Sorting'),
        ),
      ),
    );
  }
}
