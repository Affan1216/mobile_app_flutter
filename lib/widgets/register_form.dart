import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_part2_ecomarket/services/firebase_service.dart';

class RegisterForm extends StatelessWidget {
  String? email;
  String? password;
  String? confirmPassword;
  var form = GlobalKey<FormState>();

  FirebaseService fbService = GetIt.instance<FirebaseService>();

  register(context) {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      if (password != confirmPassword) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Password and Confirm Password do not match!')));
        return;
      }
      fbService.register(email, password).then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User Registered successfully!'),
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
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please provide an email address.";
              } else if (!value.contains('@')) {
                return "Please provide a valid email address.";
              } else {
                return null;
              }
            },
            onSaved: (value) {
              email = value;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please provide a password.';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters.';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              password = value;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please provide a password.';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters.';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              confirmPassword = value;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              register(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Or sign up with', style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              await fbService.signInWithGoogle();
              final user = fbService.getCurrentUser();
              if (user != null) {
                Navigator.pushReplacementNamed(context, '/MainHomeScreen');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Google Sign-In failed'),
                ));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey),
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
            icon: Image.asset('images/google_logo.png', height: 24),
            label: Text('Sign in with Google',
                style: TextStyle(fontSize: 18, color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
