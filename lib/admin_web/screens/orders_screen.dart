import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'products_page.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Future<void> updateOrderStatus(
  //   String orderId,
  //   String status,
  //   String productId,
  //   int quantity,
  // ) async {
  //   await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
  //     'status': status,
  //   });

  //   if (status == "accepted") {
  //     final productRef = FirebaseFirestore.instance
  //         .collection('products')
  //         .doc(productId);

  //     final productDoc = await productRef.get();

  //     int currentQuantity = productDoc['quantity'];

  //     await productRef.update({'quantity': currentQuantity - quantity});
  //   }
  // }
  Future<void> updateOrderStatus(
    String orderId,
    String status,
    String productId,
    int quantity,
  ) async {
    print("بدأ التنفيذ");

    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': status,
    });

    print("تم تحديث الطلب");

    if (status == "accepted") {
      final productRef = FirebaseFirestore.instance
          .collection('products')
          .doc(productId);

      final productDoc = await productRef.get();

      print(productDoc.data());

      int currentQuantity = int.parse(productDoc['quantity'].toString());

      int newQuantity = currentQuantity - quantity;

      print("الكمية الجديدة: $newQuantity");

      await productRef.update({'quantity': newQuantity});

      print("تم إنقاص الكمية");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,

        child: Row(
          children: [
            Container(
              width: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 73, 48, 38),
                    Color.fromARGB(255, 100, 66, 53),
                    Color.fromARGB(255, 147, 104, 87),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  const Text(
                    "Honney App",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _menuItem("الرئيسية", icon: Icons.home),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProductsPage()),
                      );
                    },
                    child: _menuItem(
                      "إدارة المنتجات",
                      icon: Icons.shopping_cart,
                    ),
                  ),

                  _menuItem("الطلبات", icon: Icons.inventory, selected: true),

                  _menuItem("العملاء", icon: Icons.people),
                ],
              ),
            ),

            /// =========================
            /// محتوى الصفحة
            /// =========================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 20),

                    const Text(
                      "إدارة الطلبات",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// رؤوس الجدول
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Row(
                        children: const [
                          Expanded(
                            child: Center(
                              child: Text(
                                "العميل",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Center(
                              child: Text(
                                "المنتج",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Center(
                              child: Text(
                                "الكمية",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Center(
                              child: Text(
                                "السعر",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Center(
                              child: Text(
                                "الحالة",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "العمليات",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// بيانات الطلبات
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('orders')
                            .snapshots(),

                        builder: (context, snapshot) {
                          /// تحميل
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          /// خطأ
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          }

                          /// لا توجد بيانات
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(child: Text("لا توجد طلبات"));
                          }

                          final orders = snapshot.data!.docs;

                          return ListView.builder(
                            itemCount: orders.length,

                            itemBuilder: (context, index) {
                              final order = orders[index];

                              /// اسم العميل
                              final data = order.data() as Map<String, dynamic>;

                              final customerName =
                                  data['customerName'] ?? 'مجهول';

                              final productName =
                                  data['productName'] ?? 'بدون اسم';

                              final quantity = data['quantity'] ?? 0;

                              final price = data['price'] ?? 0;

                              final status = data['status'] ?? 'pending';
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),

                                padding: const EdgeInsets.all(15),

                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: Row(
                                  children: [
                                    /// العميل
                                    Expanded(
                                      child: Center(child: Text(customerName)),
                                    ),

                                    /// المنتج
                                    Expanded(
                                      child: Center(child: Text(productName)),
                                    ),

                                    /// الكمية
                                    Expanded(
                                      child: Center(
                                        child: Text(quantity.toString()),
                                      ),
                                    ),

                                    /// السعر
                                    Expanded(
                                      child: Center(
                                        child: Text(price.toString()),
                                      ),
                                    ),

                                    /// الحالة
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          status,

                                          style: TextStyle(
                                            color: status == "accepted"
                                                ? Colors.green
                                                : status == "cancelled"
                                                ? Colors.red
                                                : Colors.orange,

                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// العمليات
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,

                                        children: [
                                          /// قبول
                                          IconButton(
                                            onPressed: () async {
                                              if (order['status'] !=
                                                  'accepted') {
                                                await updateOrderStatus(
                                                  order.id,
                                                  "accepted",
                                                  order['productId'],
                                                  order['quantity'],
                                                );
                                              }
                                            },

                                            icon: const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await updateOrderStatus(
                                                order.id,
                                                "cancelled",
                                                order['productId'],
                                                order['quantity'],
                                              );
                                            },

                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),

                                          /// رفض
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// =========================
            /// SIDEBAR
            /// =========================
          ],
        ),
      ),
    );
  }

  Widget _menuItem(String text, {bool selected = false, IconData? icon}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: selected ? Colors.white.withOpacity(0.15) : Colors.transparent,
      ),

      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),

          const SizedBox(width: 10),

          Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
