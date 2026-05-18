import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/models/order_model.dart';

class OrderService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// 🔹 جلب كل الطلبات (للأدمن)
  Stream<List<OrderModel>> getOrders() {
    return firestore.collection('orders').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// 🔹 جلب طلبات مستخدم معين (للعميل)
  Stream<QuerySnapshot> getUserOrders(String userId) {
    return firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// 🔹 قبول الطلب
  Future<void> acceptOrder(OrderModel order) async {
    final productRef =
    firestore.collection('products').doc(order.productId);

    final productSnapshot = await productRef.get();

    if (!productSnapshot.exists) {
      throw Exception("المنتج غير موجود");
    }

    final productData = productSnapshot.data()!;

    int currentQuantity = productData['quantity'] ?? 0;

    if (currentQuantity < order.quantity) {
      throw Exception("الكمية غير كافية");
    }

    await productRef.update({
      "quantity": currentQuantity - order.quantity,
    });

    await firestore.collection('orders').doc(order.id).update({
      "status": "accepted",
    });
  }

  /// 🔹 إلغاء الطلب
  Future<void> cancelOrder(String orderId) async {
    await firestore.collection('orders').doc(orderId).update({
      "status": "cancelled",
    });
  }
}