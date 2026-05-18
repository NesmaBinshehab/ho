import 'package:flutter/material.dart';
import 'package:honnyapp/admin_web/screens/orders_screen.dart';

import '../../core/services/product_service.dart';
import '../../shared/models/product_model.dart';
import 'product_form_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductsService _service = ProductsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          /// 🟤 Sidebar
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

                _menuItem(
                  "إدارة المنتجات",
                  icon: Icons.inventory,
                  selected: true,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrdersScreen()),
                    );
                  },
                  child: _menuItem("الطلبات", icon: Icons.shopping_cart),
                ),

                _menuItem("العملاء", icon: Icons.people),
              ],
            ),
          ),

          /// 🟢 Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// العنوان + الأزرار
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "إدارة المنتجات",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProductFormPage(),
                                ),
                              );

                              if (result != null && result is ProductModel) {
                                await _service.saveProduct(result);
                              }
                            },
                            child: const Text("إضافة منتج"),
                          ),

                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              await _service.importExcel();
                            },
                            child: const Text("استيراد Excel"),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// الجدول
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      /// ✅ حل مشكلة overflow
                      child: Column(
                        children: [
                          /// Header
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "الصورة",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "اسم المنتج",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "رقم المنتج",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "السعر",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "الحجم",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "الكمية",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "الوصف",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      "الإجراءات",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Divider(),

                          /// Rows
                          Expanded(
                            child: StreamBuilder<List<ProductModel>>(
                              stream: _service.getProducts(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Center(
                                    child: Text("لا يوجد منتجات"),
                                  );
                                }

                                final products = snapshot.data!;

                                return ListView.builder(
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final p = products[index];

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),

                                      child: Row(
                                        children: [
                                          /// الصورة
                                          Expanded(
                                            flex: 1,
                                            child: Image.asset(
                                              "assets/images/${p.imageIndex}.png",
                                              height: 50,
                                            ),
                                          ),

                                          /// الاسم
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              p.name,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          /// الرقم
                                          Expanded(
                                            flex: 1,
                                            child: Text(p.number.toString()),
                                          ),

                                          /// السعر
                                          Expanded(
                                            flex: 1,
                                            child: Text(p.price.toString()),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(p.size),
                                          ),

                                          /// الكمية
                                          Expanded(
                                            flex: 1,
                                            child: Text(p.quantity.toString()),
                                          ),

                                          /// الوصف
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              p.description,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          /// العمليات
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Colors.orange,
                                                  ),
                                                  onPressed: () async {
                                                    final result =
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                ProductFormPage(
                                                                  product: p,
                                                                ),
                                                          ),
                                                        );

                                                    if (result != null &&
                                                        result
                                                            is ProductModel) {
                                                      await _service
                                                          .saveProduct(result);
                                                    }
                                                  },
                                                ),

                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    await _service
                                                        .deleteProduct(p.id!);
                                                  },
                                                ),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Sidebar Item
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
