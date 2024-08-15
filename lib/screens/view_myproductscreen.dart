import 'package:flutter/material.dart';
import 'package:mbap_part2_ecomarket/screens/product.dart';
import 'package:share_plus/share_plus.dart';

class ViewProductScreen extends StatelessWidget {
  static const routeName = '/view-product';


  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)?.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (product.imageUrls.isNotEmpty)
                Image.network(
                  product.imageUrls[0],
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 16),
              const Divider(),
              Text(
                'Name: ${product.name}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Price: \$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20),
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Quantity: ${product.quantity}',
                style: const TextStyle(fontSize: 20),
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Location: ${product.location}',
                style: const TextStyle(fontSize: 20),
              ),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Description: ${product.description}',
                style: const TextStyle(fontSize: 20),
              ),
              const Divider(),
              ElevatedButton(
                child: Text('Share Text'),
                onPressed: () async{
                  final message = 
                  "Check out this product: Product:${product.imageUrls[0]}  Name: ${product.name}Price: \$${product.price.toStringAsFixed(2)}Quantity: ${product.quantity}Location: ${product.location}Description: ${product.description}";
                  await Share.share(message);
                }
                )
            ],
          ),
        ),
      ),
    );
  }
}
