import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final _cartRef = FirebaseFirestore.instance.collection('cart');

  Future<void> addToCart(Map<String, dynamic> product) async {
    final productId = product['id'];

    final doc = await _cartRef.doc(productId).get();

    if (doc.exists) {
      await _cartRef.doc(productId).update({
        'qty': FieldValue.increment(1),
      });
    } else {
      await _cartRef.doc(productId).set({
        'productId': productId,
        'name': product['name'],
        'price': product['price'],
        'image': product['image'],
        'qty': 1,
      });
    }
  }

  Future<void> increase(String id) async {
    await _cartRef.doc(id).update({
      'qty': FieldValue.increment(1),
    });
  }

  Future<void> decrease(String id, int qty) async {
    if (qty > 1) {
      await _cartRef.doc(id).update({
        'qty': FieldValue.increment(-1),
      });
    }
  }

  Future<void> deleteItem(String id) async {
    await _cartRef.doc(id).delete();
  }

  Stream<QuerySnapshot> getCart() {
    return _cartRef.snapshots();
  }
}