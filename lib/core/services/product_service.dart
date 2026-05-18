import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' hide Border;
import 'dart:typed_data';

import '../../shared/models/product_model.dart';

class ProductsService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// حفظ منتج
  Future<void> saveProduct(ProductModel product) async {
    if (product.id == null) {
      await firestore.collection('products').add(product.toMap());
    } else {
      await firestore
          .collection('products')
          .doc(product.id)
          .update(product.toMap());
    }
  }

  /// حذف منتج
  Future<void> deleteProduct(String? id) async {
    if (id == null) return;

    await firestore.collection('products').doc(id).delete();
  }

  /// جلب المنتجات
  Stream<List<ProductModel>> getProducts() {
    return firestore
        .collection('products')
        .orderBy('number')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// استيراد Excel
  Future<void> importExcel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );

    if (result == null) return;

    Uint8List? bytes = result.files.single.bytes;

    if (bytes == null) return;

    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows.skip(1)) {
        final name = row[0]?.value?.toString() ?? '';

        final number =
            int.tryParse(row[1]?.value?.toString() ?? '0') ?? 0;

        final price =
            int.tryParse(row[2]?.value?.toString() ?? '0') ?? 0;

        final size = row[3]?.value?.toString() ?? '';

        final quantity =
            int.tryParse(row[4]?.value?.toString() ?? '0') ?? 0;

        final description = row[5]?.value?.toString() ?? '';

        final imageIndex =
            int.tryParse(row[6]?.value?.toString() ?? '1') ?? 1;

        ProductModel product = ProductModel(
          name: name,
          number: number,
          price: price,
          size: size,
          quantity: quantity,
          description: description,
          imageIndex: imageIndex,
        );

        await saveProduct(product);
      }
    }
  }
}