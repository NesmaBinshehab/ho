
import 'package:flutter/material.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
const CartScreen({super.key});

@override
Widget build(BuildContext context) {
// مؤقتًا بيانات وهمية (لاحقًا من Firebase)
List<Map<String, String>> cartItems = [
{"name": "عسل سدر", "price": "5000"},
{"name": "عسل سمر", "price": "4500"},
];

return Scaffold(
appBar: AppBar(
title: const Text("السلة 🛒"),
centerTitle: true,
),
body: ListView.builder(
itemCount: cartItems.length,
itemBuilder: (context, index) {
var item = cartItems[index];

return CartItem(
name: item['name']!,
price: item['price']!,
onDelete: () {
// لاحقًا حذف من Firebase
},
);
},
),
);
}
}