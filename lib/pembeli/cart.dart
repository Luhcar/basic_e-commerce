import 'package:ecommerce/pembeli/success_checkout.dart';
import 'package:flutter/material.dart';
import '../database_helper.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance
            .queryAllRowsCart(), // Memanggil data dari database
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:
                  CircularProgressIndicator(), // Menampilkan indikator saat menunggu
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                  'Error: ${snapshot.error}'), // Menampilkan error jika ada
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                  'Your Cart is Empty'), // Menampilkan pesan jika keranjang kosong
            );
          } else {
            final cartItems = snapshot.data!;
            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item['name']), // Nama produk
                  subtitle: Text('Rp ${item['price']}'), // Harga produk
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await DatabaseHelper.instance.deleteCart(item['id']);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Item removed from cart')),
                      );
                      // Perbarui tampilan setelah penghapusan
                      (context as Element).reassemble();
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Navigasikan ke halaman berhasil checkout
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CheckoutSuccessPage()),
            );
          },
          child: Text('Checkout'),
        ),
      ),
    );
  }
}
