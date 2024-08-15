import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbap_part2_ecomarket/screens/product.dart';
import 'package:mbap_part2_ecomarket/services/firebase_service.dart';
import 'package:mbap_part2_ecomarket/widgets/bottom_navigation.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = '/edit-product';


  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final FirebaseService fbService = GetIt.instance<FirebaseService>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final List<File> _selectedImages = [];
  List<String> _existingImageUrls = [];
  String? _productId;
  String _selectedCategory = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final product = ModalRoute.of(context)!.settings.arguments as Product?;
    if (product != null) {
      _nameController.text = product.name;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toString();
      _quantityController.text = product.quantity.toString();
      _locationController.text = product.location;
      _existingImageUrls = product.imageUrls;
      _productId = product.id;
      _selectedCategory = product.category;
    }
  }

  void _pickImage(int sourceType) async {
    if (_selectedImages.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only add up to 3 images.')),
      );
      return;
    }

    final pickedFile = await ImagePicker().pickImage(
      source: sourceType == 0 ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 600,
      imageQuality: 50,
      maxHeight: 150,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      List<String> imageUrls = List.from(_existingImageUrls);
      for (var image in _selectedImages) {
        String? imageUrl = await fbService.addProductPhoto(image);
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }
      if (_productId != null) {
        try {
          await fbService.updateProduct(
            _productId!,
            _nameController.text,
            imageUrls,
            _descriptionController.text,
            int.parse(_quantityController.text),
            double.parse(_priceController.text),
            _locationController.text,
            Timestamp.now().toDate(),
            _selectedCategory,
          );
          _showAlertDialog('Product Updated', 'Your product has been successfully updated.');
        } catch (e) {
          _showSnackBar('Error updating product: $e');
        }
      }
    }
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/Myproduct');
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: _submitProduct,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_a_photo, size: 40),
                      onPressed: () => _pickImage(0),
                    ),
                    IconButton(
                      icon: const Icon(Icons.image, size: 40),
                      onPressed: () => _pickImage(1),
                    ),
                    const SizedBox(width: 10),
                    const Text('Add up to 3 images'),
                  ],
                ),
                const SizedBox(height: 20),
                if (_selectedImages.isNotEmpty || _existingImageUrls.isNotEmpty)
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length + _existingImageUrls.length,
                      itemBuilder: (context, index) {
                        if (index < _existingImageUrls.length) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.network(
                              _existingImageUrls[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.file(
                              _selectedImages[index - _existingImageUrls.length],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Product Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Product Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: 'Product Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Category:', style: TextStyle(fontSize: 18)),
                RadioListTile<String>(
                  title: const Text('Buy'),
                  value: 'Buy',
                  groupValue: _selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Free'),
                  value: 'Free',
                  groupValue: _selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Wanted'),
                  value: 'Wanted',
                  groupValue: _selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitProduct,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(initialIndex: 1),
    );
  }
}
