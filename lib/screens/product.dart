import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  List<String> imageUrls;
  String description;
  int quantity;
  double price;
  String location;
  DateTime createdate;
  String category;

  Product({
    required this.id,
    required this.name,
    required this.imageUrls,
    required this.description,
    required this.quantity,
    required this.price,
    required this.location,
    required this.createdate,
    required this.category
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      description: data['description'] ?? '',
      quantity: data['quantity'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      location: data['location'] ?? '',
      createdate: (data['createdDate'] as Timestamp).toDate(),
      category: data['category'] ?? '',
    );
  }
}
