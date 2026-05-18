import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../../core/services/product_service.dart';
import '../../core/services/cart_service.dart';
import '../../core/constants/app_colors.dart';
import 'cart_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();
    final cartService = CartService();

    return Scaffold(
      backgroundColor: AppColors.white,

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 40,
              bottom: 15,
              left: 15,
              right: 15,
            ),
            color: AppColors.primary,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const Text(
                  "مختاراتنا الذهبية لكم",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 28),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream: productService.getProducts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final products = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final data = product.data() as Map<String, dynamic>;
                    data['id'] = product.id;

                    return ProductCard(
                      name: data['name'],
                      desc: data['description'],
                      image: data['image'],
                      price: data['price'].toDouble(),
                      onAddToCart: () => cartService.addToCart(data),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}