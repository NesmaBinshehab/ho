import 'package:flutter/material.dart';

import '../../core/services/product_service.dart';
import '../../shared/models/product_model.dart';

class ProductFormPage extends StatefulWidget {
  final ProductModel? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final name = TextEditingController();
  final number = TextEditingController();
  final price = TextEditingController();
  final size = TextEditingController();
  final quantity = TextEditingController();
  final description = TextEditingController();

  final ProductService service = ProductService();

  int imageIndex = 1;
  String? docId;

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      final p = widget.product!;

      name.text = p.name;
      number.text = p.number.toString();
      price.text = p.price.toString();
      size.text = p.size;
      quantity.text = p.quantity.toString();
      description.text = p.description;

      imageIndex = p.imageIndex;
      docId = p.id;
    }
  }

  Future<void> save() async {
    if (name.text.isEmpty ||
        number.text.isEmpty ||
        price.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("املأ الحقول المطلوبة")),
      );
      return;
    }

    final product = ProductModel(
      id: docId,
      name: name.text,
      number: int.tryParse(number.text) ?? 0,
      price: int.tryParse(price.text) ?? 0,
      size: size.text,
      quantity: int.tryParse(quantity.text) ?? 0,
      description: description.text,
      imageIndex: imageIndex,
    );

    try {
      await service.saveProduct(product);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة منتج")),

      body: Directionality(
        textDirection: TextDirection.rtl,

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// الفورم
              Expanded(
                flex: 3,

                child: Column(
                  children: [
                    Row(
                      children: [
                        _field("اسم المنتج", name),
                        _field("رقم المنتج", number),
                        _field("السعر", price),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        _field("الحجم", size),
                        _field("الكمية", quantity),
                        _field("الوصف", description),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: save,
                          child: const Text("حفظ المنتج"),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("إلغاء"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              /// صورة المنتج
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 150),

                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Column(
                    children: [
                      const Text("صورة المنتج"),
                      const SizedBox(height: 10),

                      Image.asset(
                        "assets/images/$imageIndex.png",
                        height: 120,
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            imageIndex++;
                            if (imageIndex > 7) imageIndex = 1;
                          });
                        },
                        child: const Text("تغيير الصورة"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}