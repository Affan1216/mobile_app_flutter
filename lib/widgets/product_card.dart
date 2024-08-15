import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final int quantity;
  final String location;
  final String imagePath;
  final VoidCallback onAddToCart;

  ProductCard({
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.location,
    required this.imagePath,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            imagePath.isNotEmpty
                ? Image.network(imagePath, width: 80, height: 80)
                : Container(width: 80, height: 80, color: Colors.grey),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(description),
                  Text('Quantity: $quantity'),
                  Text('Location: $location'),
                  Text('\$$price', style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: onAddToCart,
            ),
          ],
        ),
      ),
    );
  }
}
