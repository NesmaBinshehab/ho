import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final _ref = FirebaseFirestore.instance.collection('products');

  Stream<QuerySnapshot> getProducts() {
    return _ref.snapshots();
  }
}