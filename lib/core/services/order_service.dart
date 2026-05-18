import 'package:cloud_firestore/cloud_firestore.dart';

import '../../shared/models/order_model.dart';

class OrderService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// جلب الطلبات
  Stream<List<OrderModel>> getOrders() {
    return firestore.collection('orders').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// قبول الطلب
  Future<void> acceptOrder(OrderModel order) async {
    final productRef = firestore.collection('products').doc(order.productId);

    final productSnapshot = await productRef.get();

    if (!productSnapshot.exists) {
      throw Exception("المنتج غير موجود");
    }

    final productData = productSnapshot.data()!;

    int currentQuantity = productData['quantity'] ?? 0;

    /// التحقق من الكمية
    if (currentQuantity < order.quantity) {
      throw Exception("الكمية غير كافية");
    }

    /// خصم الكمية
    await productRef.update({"quantity": currentQuantity - order.quantity});

    /// تحديث حالة الطلب
    await firestore.collection('orders').doc(order.id).update({
      "status": "accepted",
    });
  }

  /// إلغاء الطلب
  Future<void> cancelOrder(String orderId) async {
    await firestore.collection('orders').doc(orderId).update({
      "status": "cancelled",
    });
  }
}
