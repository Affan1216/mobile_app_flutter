import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_part2_ecomarket/screens/resetPasswordScreen.dart';
import 'package:mbap_part2_ecomarket/widgets/login_form.dart';
import 'package:mbap_part2_ecomarket/widgets/register_form.dart';
import 'package:mbap_part2_ecomarket/services/firebase_service.dart';

class AuthScreen extends StatefulWidget {
  static String routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool loginScreen = true;
  final FirebaseService _authService = GetIt.instance<FirebaseService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text('Eco Market ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            loginScreen ? LoginForm() : RegisterForm(),
            const SizedBox(height: 10),
            loginScreen
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        loginScreen = false;
                      });
                    },
                    child: const Text('No account? Sign up here!', style: TextStyle(color: Colors.black)))
                : TextButton(
                    onPressed: () {
                      setState(() {
                        loginScreen = true;
                      });
                    },
                    child: const Text('Existing user? Login in here!', style: TextStyle(color: Colors.black))),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ResetPasswordScreen.routeName);
              },
              child: const Text('Forgotten Password?', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
