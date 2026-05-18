import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/order_service.dart';

class OrderTrackingScreen extends StatelessWidget {
  OrderTrackingScreen({super.key});

  final OrderService _orderService = OrderService();

  String statusText(String status) {
    switch (status) {
      case "pending":
        return "قيد المراجعة";
      case "preparing":
        return "قيد التحضير";
      case "shipping":
        return "في الطريق 🚚";
      case "delivered":
        return "تم التسليم";
      default:
        return "غير معروف";
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "preparing":
        return Colors.blue;
      case "shipping":
        return Colors.purple;
      case "delivered":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  double progress(String status) {
    switch (status) {
      case "pending":
        return 0.2;
      case "preparing":
        return 0.5;
      case "shipping":
        return 0.8;
      case "delivered":
        return 1.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("يجب تسجيل الدخول أولاً"),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "تتبع الطلبات",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFAD390),
      ),

      body: StreamBuilder(
        stream: _orderService.getUserOrders(user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(
              child: Text(
                "لا توجد طلبات بعد 🛒",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final doc = orders[index];
              final data = doc.data() as Map<String, dynamic>;

              final status = data['status'] ?? "pending";

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// الحالة + السعر
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor(status).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              statusText(status),
                              style: TextStyle(
                                color: statusColor(status),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),

                          Text(
                            "${data['total']} ريال",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// المنتجات داخل الطلب
                      ...List.generate(
                        (data['products'] as List).length,
                            (i) {
                          final p = data['products'][i];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                const Icon(Icons.brightness_1,
                                    size: 6, color: Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "${p['name']} × ${p['qty']}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      /// progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress(status),
                          minHeight: 8,
                          backgroundColor: Colors.grey[200],
                          color: statusColor(status),
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
    );
  }
}