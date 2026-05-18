class ProductModel {
  String? id;
  String name;
  int number;
  int price;
  String size;
  int quantity;
  String description;
  int imageIndex;

  ProductModel({
    this.id,
    required this.name,
    required this.number,
    required this.price,
    required this.size,
    required this.quantity,
    required this.description,
    required this.imageIndex,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductModel(
      id: docId,
      name: map['name'] ?? '',
      number: map['number'] ?? 0,
      price: map['price'] ?? 0,
      size: map['size'] ?? '',
      quantity: map['quantity'] ?? 0,
      description: map['description'] ?? '',
      imageIndex: map['imageIndex'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "number": number,
      "price": price,
      "size": size,
      "quantity": quantity,
      "description": description,
      "imageIndex": imageIndex,
    };
  }
}
