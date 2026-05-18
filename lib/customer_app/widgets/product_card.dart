import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String desc;
  final String image;
  final double price;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.name,
    required this.desc,
    required this.image,
    required this.price,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      height: 185,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              left: 18,
              top: 18,
              bottom: 16,
              right: 155,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF212121),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(name,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),

                const SizedBox(height: 8),

                Text(desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70)),

                const Spacer(),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9AE62),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$price ريال",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(width: 10),

                    GestureDetector(
                      onTap: onAddToCart,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9AE62),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.add_shopping_cart,
                            color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          Positioned(
            right: 10,
            top: -20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                image,
                width: 135,
                height: 155,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}