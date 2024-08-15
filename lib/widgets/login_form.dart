import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_part2_ecomarket/services/firebase_service.dart';

class LoginForm extends StatelessWidget {
  FirebaseService fbService = GetIt.instance<FirebaseService>();
  String? email;
  String? password;
  var form = GlobalKey<FormState>();
  login(context) {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      fbService.login(email, password).then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Login successfully!'),
        ));
      }).catchError((error) {
        FocusScope.of(context).unfocus();
        String message = error.toString();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty)
                return "Please provide an email address.";
              else if (!value.contains('@'))
                return "Please provide a valid email address.";
              return null;
            },
            onSaved: (value) {
              email = value;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.visibility),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please provide a password.';
              else if (value.length < 6)
                return 'Password must be at least 6 characters.';
              return null;
            },
            onSaved: (value) {
              password = value;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              login(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, 
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text('Login', style: TextStyle(fontSize: 16)),
            
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(child: Divider(thickness: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('OR'),
              ),
              Expanded(child: Divider(thickness: 1)),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              await fbService.signInWithGoogle();
              final user = fbService.getCurrentUser();
              if (user != null) {
                Navigator.pushReplacementNamed(context, '/main');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Google Sign-In failed'),
                ));
              }
            },
            icon: Image.asset('images/google_logo.png', height: 24, width: 24),
            label: const Text('Sign in with Google', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}
