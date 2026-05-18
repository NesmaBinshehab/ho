class OrderModel {
  String? id;
  String customerName;
  String productId;
  String productName;
  int quantity;
  int price;
  int totalPrice;
  String status;
  int imageIndex;

  OrderModel({
    this.id,
    required this.customerName,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.status,
    required this.imageIndex,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    return OrderModel(
      id: docId,
      customerName: map['customerName'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: map['price'] ?? 0,
      totalPrice: map['totalPrice'] ?? 0,
      status: map['status'] ?? 'pending',
      imageIndex: map['imageIndex'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "customerName": customerName,
      "productId": productId,
      "productName": productName,
      "quantity": quantity,
      "price": price,
      "totalPrice": totalPrice,
      "status": status,
      "imageIndex": imageIndex,
    };
  }
}