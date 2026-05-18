class OrderModel {
  final String id;
  final String userId;
  final List products;
  final double total;
  final String status;

  OrderModel({
    required this.id,
    required this.userId,
    required this.products,
    required this.total,
    required this.status,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> data) {
    return OrderModel(
      id: id,
      userId: data['userId'],
      products: data['products'],
      total: data['total'].toDouble(),
      status: data['status'],
    );
  }
}