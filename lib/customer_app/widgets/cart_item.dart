import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String name;
  final String price;
  final VoidCallback onDelete;

  const CartItem({
    super.key,
    required this.name,
    required this.price,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        title: Text(name),
        subtitle: Text("$price ريال"),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}