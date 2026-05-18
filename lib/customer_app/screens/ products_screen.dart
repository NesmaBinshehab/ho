import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("متجر العسل 🍯"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("لا توجد منتجات"));
          }

          var products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];

              return ProductCard(
                name: product['name'],
                price: product['price'].toString(),
                image: product['image'],
                onAdd: () {
                  // لاحقًا نربطه بالسلة
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("تمت الإضافة للسلة")),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}