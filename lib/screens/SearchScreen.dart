import 'package:flutter/material.dart';
import 'package:mbap_part2_ecomarket/widgets/category_button.dart';


class SearchScreen extends StatefulWidget {
  static const routeName = '/Search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedButtonIndex = -1;

  void _onButtonPressed(int index) {
    setState(() {
      _selectedButtonIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), 
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           Row( 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CategoryButton(
                  text: 'Buy',
                  index: 0,
                  selectedButtonIndex: _selectedButtonIndex,
                  icon: Icons.shopping_cart,
                  onPressed: _onButtonPressed,
                ),
                const SizedBox(width: 8),
                CategoryButton(
                  text: 'Free',
                  index: 1,
                  selectedButtonIndex: _selectedButtonIndex,
                  icon: Icons.card_giftcard,
                  onPressed: _onButtonPressed,
                ),
                const SizedBox(width: 8),
                CategoryButton(
                  text: 'Wanted',
                  index: 2,
                  selectedButtonIndex: _selectedButtonIndex,
                  icon: Icons.search,
                  onPressed: _onButtonPressed,
                ),
              ],
            ),
            const SizedBox(height: 20),
  
          ],

        ),
      ),
    );
  }

  

}
