import 'package:flutter/material.dart';
import 'package:mbap_part2_ecomarket/screens/view_myproductscreen.dart';
import 'package:mbap_part2_ecomarket/services/firebase_service.dart';
import 'package:mbap_part2_ecomarket/widgets/app_drawer.dart';
import 'package:mbap_part2_ecomarket/widgets/bottom_navigation.dart';
import 'package:mbap_part2_ecomarket/widgets/category_button.dart';
import 'package:mbap_part2_ecomarket/widgets/myproduct_card.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_part2_ecomarket/screens/product.dart';


class MyProductScreen extends StatefulWidget {
  static const routeName = '/Myproduct';

  @override
  State<MyProductScreen> createState() => _MyProductScreenState();
}

class _MyProductScreenState extends State<MyProductScreen> {
  final FirebaseService firebaseService = GetIt.instance<FirebaseService>();
  int _selectedSortOption = 0;
  String _selectedCategory = 'All';

  void _editProduct(Product product) {
    Navigator.pushNamed(context, '/edit', arguments: product);
  }

  void _removeProduct(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await firebaseService.deleteProduct(id);
                  _showSnackBar('Product deleted successfully.');
                } catch (e) {
                  _showSnackBar('Error deleting product: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Sort by:', style: TextStyle(fontSize: 18)),
                    RadioListTile(
                      title: const Text('Newest'),
                      value: 0,
                      groupValue: _selectedSortOption,
                      onChanged: (value) {
                        setModalState(() {
                          _selectedSortOption = value as int;
                        });
                        setState(() {});
                      },
                    ),
                    RadioListTile(
                      title: const Text('Older'),
                      value: 1,
                      groupValue: _selectedSortOption,
                      onChanged: (value) {
                        setModalState(() {
                          _selectedSortOption = value as int;
                        });
                        setState(() {});
                      },
                    ),
                    RadioListTile(
                      title: const Text('Highest price'),
                      value: 2,
                      groupValue: _selectedSortOption,
                      onChanged: (value) {
                        setModalState(() {
                          _selectedSortOption = value as int;
                        });
                        setState(() {});
                      },
                    ),
                    RadioListTile(
                      title: const Text('Lowest price'),
                      value: 3,
                      groupValue: _selectedSortOption,
                      onChanged: (value) {
                        setModalState(() {
                          _selectedSortOption = value as int;
                        });
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onCategorySelected(int index) {
    setState(() {
      switch (index) {
        case 0:
          _selectedCategory = 'All';
          break;
        case 1:
          _selectedCategory = 'Buy';
          break;
        case 2:
          _selectedCategory = 'Free';
          break;
        case 3:
          _selectedCategory = 'Wanted';
          break;
      }
    });
  }

  List<Product> _sortProducts(List<Product> products) {
    switch (_selectedSortOption) {
      case 0:
        products.sort((a, b) => b.createdate.compareTo(a.createdate)); 
        break;
      case 1:
        products.sort((a, b) => a.createdate.compareTo(b.createdate)); 
        break;
      case 2:
        products.sort((a, b) => b.price.compareTo(a.price)); 
        break;
      case 3:
        products.sort((a, b) => a.price.compareTo(b.price)); 
        break;
    }
    return products;
  }

  List<Product> _filterProducts(List<Product> products) {
    if (_selectedCategory == 'All') {
      return products;
    } else {
      return products.where((product) => product.category == _selectedCategory).toList();
    }
  }

  void _viewProduct(Product product) {
    Navigator.pushNamed(
      context,
      ViewProductScreen.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterModal(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CategoryButton(
                          text: 'All',
                          index: 0,
                          selectedButtonIndex: _selectedCategory == 'All' ? 0 : -1,
                          icon: Icons.all_inclusive,
                          onPressed: _onCategorySelected,
                        ),
                        const SizedBox(width: 6),
                        CategoryButton(
                          text: 'Buy',
                          index: 1,
                          selectedButtonIndex: _selectedCategory == 'Buy' ? 1 : -1,
                          icon: Icons.shopping_cart,
                          onPressed: _onCategorySelected,
                        ),
                        const SizedBox(width: 6),
                        CategoryButton(
                          text: 'Free',
                          index: 2,
                          selectedButtonIndex: _selectedCategory == 'Free' ? 2 : -1,
                          icon: Icons.card_giftcard,
                          onPressed: _onCategorySelected,
                        ),
                        const SizedBox(width: 6),
                        CategoryButton(
                          text: 'Wanted',
                          index: 3,
                          selectedButtonIndex: _selectedCategory == 'Wanted' ? 3 : -1,
                          icon: Icons.search,
                          onPressed: _onCategorySelected,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: firebaseService.getproducts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var products = snapshot.data!;
                products = _filterProducts(products); 
                products = _sortProducts(products); 

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () => _viewProduct(product), 
                      child: MyProductCard(
                        title: product.name,
                        description: product.description,
                        price: product.price,
                        quantity: product.quantity,
                        location: product.location,
                        imagePath: product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
                        OnEdit: () => _editProduct(product),
                        OnDelete: () => _removeProduct(product.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      endDrawer: app_drawer(),
      bottomNavigationBar: const BottomBar(),
    );
  }
}