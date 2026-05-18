import 'package:flutter/material.dart';
import '../../core/services/cart_service.dart';
import '../../core/constants/app_colors.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String name;
  final num price;
  final int qty;
  final String image;

  const CartItem({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              image,
              width: 90,
              height: 90,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("$price ريال"),

                Row(
                  children: [
                    IconButton(
                      onPressed: () => cartService.decrease(id, qty),
                      icon: const Icon(Icons.remove),
                    ),
                    Text("$qty"),
                    IconButton(
                      onPressed: () => cartService.increase(id),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () => cartService.deleteItem(id),
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}