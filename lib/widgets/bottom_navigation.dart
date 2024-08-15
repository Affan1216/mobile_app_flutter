import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final int initialIndex;

  const BottomBar({super.key, this.initialIndex = 0});
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/main');
        break;
      case 1:
        Navigator.pushNamed(context, '/Add');
        break;
      case 2:
        Navigator.pushNamed(context, '/Cart');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            color: _selectedIndex == 0 ? Colors.green : Colors.grey,
          ),
          activeIcon: const Icon(
            Icons.home,
            color: Colors.green,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_box_outlined,
            color: _selectedIndex == 1 ? Colors.green : Colors.grey,
          ),
          activeIcon: const Icon(
            Icons.add_box,
            color: Colors.green,
          ),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: _selectedIndex == 2 ? Colors.green : Colors.grey,
          ),
          activeIcon: const Icon(
            Icons.shopping_cart,
            color: Colors.green,
          ),
          label: 'Cart',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      showUnselectedLabels: true,
      onTap: onItemTapped,
    );
  }
}
