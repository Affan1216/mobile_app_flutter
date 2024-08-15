import 'package:flutter/material.dart';
import 'package:mbap_part2_ecomarket/widgets/appbackground.dart';

class LogoScreen extends StatelessWidget {
  static const routeName = '/';


  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo2.png',
              height: 150,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Click Here'),
              onPressed: () {
                Navigator.pushNamed(context, '/auth');
              },
            ),
          ],
        ),
      ),
    );
  }
}
