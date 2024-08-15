import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {

  final String text;
  final int index;
  final int selectedButtonIndex;
  final IconData icon;
  final ValueChanged<int> onPressed;

  const CategoryButton({super.key, 
    required this.text,
    required this.index,
    required this.selectedButtonIndex,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        onPressed(index);
      },
      icon: Icon(icon, color: selectedButtonIndex == index ? Colors.white : Colors.grey),
      label: Text(
        text,
        style: TextStyle(
          color: selectedButtonIndex == index ? Colors.white : Colors.grey,
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: selectedButtonIndex == index ? Colors.green : Colors.white,
        side: const BorderSide(color: Colors.grey),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 0,
      ),
    );
  }
}