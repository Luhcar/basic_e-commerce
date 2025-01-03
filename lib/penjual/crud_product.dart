import 'dart:io';
import 'package:ecommerce/database_helper.dart';
import 'package:ecommerce/penjual/edit_item.dart';
import 'package:ecommerce/login.dart';
import 'package:ecommerce/penjual/add_product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CrudProductPage extends StatefulWidget {
  const CrudProductPage({Key? key}) : super(key: key);

  @override
  State<CrudProductPage> createState() => _CrudProductPageState();
}

class _CrudProductPageState extends State<CrudProductPage> {
  late Future<List<Map<String, dynamic>>> _productList;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _selectedImage;

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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder:  (context) => AddItemPage())
            ).then((_) => _refreshProducts()),
            icon: const Icon(Icons.add),
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
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(image: FileImage(File(product['imagePath']) ),fit: BoxFit.cover, height: 110, width: 150),
                          SizedBox(height: 10.0),
                          Text(
                            product['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Rp. ${product['price']}'),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder:  (context) => EditItemPage(item: product,))
                          ).then((_) => _refreshProducts()),
                          child: const Text('Edit'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await DatabaseHelper.instance.deleteProduct(product['id']);
                            _refreshProducts();
                          },
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}