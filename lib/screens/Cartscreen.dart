import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_part2_ecomarket/screens/product.dart';
import 'package:mbap_part2_ecomarket/services/firebase_service.dart';
import 'package:mbap_part2_ecomarket/widgets/app_drawer.dart';
import 'package:mbap_part2_ecomarket/widgets/bottom_navigation.dart';
import 'package:mbap_part2_ecomarket/widgets/product_card.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/Cart';

  final FirebaseService firebaseService = GetIt.instance<FirebaseService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Cart'),
      ),
      body: StreamBuilder<List<Product>>(
        stream: firebaseService.getproducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var cartProducts = snapshot.data!;

          if (cartProducts.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return ListView.builder(
            itemCount: cartProducts.length,
            itemBuilder: (context, index) {
              final product = cartProducts[index];
              return ProductCard(
                title: product.name,
                description: product.description,
                price: product.price,
                quantity: product.quantity,
                location: product.location,
                imagePath: product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
                onAddToCart: () {},
              );
            },
          );
        },
      ),
      endDrawer: app_drawer(),
      bottomNavigationBar: const BottomBar(initialIndex: 2),
    );
  }
}
