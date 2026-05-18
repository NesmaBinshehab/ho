import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/cart_item.dart';
import '../../core/services/cart_service.dart';
import '../../core/constants/app_colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> checkout(
      List<QueryDocumentSnapshot> items,
      double total,
      BuildContext context,
      ) async {
    final ordersRef = FirebaseFirestore.instance.collection('orders');
    final cartService = CartService();

    List<Map<String, dynamic>> products = items.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        "name": data["name"],
        "price": data["price"],
        "qty": data["qty"],
        "image": data["image"],
      };
    }).toList();

    await ordersRef.add({
      "products": products,
      "total": total,
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    });

    for (var doc in items) {
      await cartService.deleteItem(doc.id);
    }

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("تم الطلب بنجاح 🎉"),
          content: const Text("تم إرسال طلبك"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("حسناً"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("سلة المشتريات"),
      ),
      body: StreamBuilder(
        stream: cartService.getCart(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;

          if (items.isEmpty) {
            return const Center(child: Text("السلة فارغة 🛒"));
          }

          double total = 0;
          for (var doc in items) {
            final data = doc.data() as Map<String, dynamic>;
            total += (data['price'] * data['qty']);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final doc = items[index];
                    final data = doc.data() as Map<String, dynamic>;

                    return CartItem(
                      id: doc.id,
                      name: data['name'],
                      price: data['price'],
                      qty: data['qty'],
                      image: data['image'],
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("الإجمالي: $total"),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                      ),
                      onPressed: () async {
                        await checkout(items, total, context);
                      },
                      child: const Text("إتمام الطلب"),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}