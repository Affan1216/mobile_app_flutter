import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:mbap_part2_ecomarket/screens/auth_screen.dart';
import 'package:mbap_part2_ecomarket/services/firebase_service.dart';
import 'package:mbap_part2_ecomarket/services/theme_service.dart';
import 'package:url_launcher/url_launcher.dart';

class app_drawer extends StatelessWidget {
  late String lat;
  late String long;

  FirebaseService fbService = GetIt.instance<FirebaseService>();
  ThemeService themeService = GetIt.instance<ThemeService>();
  logOut(context) {
    return fbService.logOut().then((value) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Logout successfully!'),
      ));
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    }).catchError((error) {
      FocusScope.of(context).unfocus();
      String message = error.toString();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    });
  }

  void _launchEmail(BuildContext context) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'itzmeaffan@gmail.com',
      query:
          'subject=${Uri.encodeFull("What is the Problem?")}&body=${Uri.encodeFull("")}',
    );
    var url = params.toString();
    print('Trying to launch $url');
    if (await canLaunch(url)) {
      await launch(url);
      print('Email client launched');
    } else {
      print('Could not launch $url');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch email client'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.person, size: 40),
              Text('User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  )),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.sentiment_satisfied),
          title: const Text('Profile'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text('Location'),
          onTap: () {
            Navigator.pushNamed(context, '/loc');
          },
        ),
        ListTile(
          leading: const Icon(Icons.list),
          title: const Text('My products'),
          onTap: () {
            Navigator.pushNamed(context, '/Myproduct');
          },
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help'),
          onTap: () => _launchEmail(context),
        ),

        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log Out'),
          onTap: () => logOut(context),
        ),
        ListTile(
          leading: const Icon(Icons.palette),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Themes'),
            GestureDetector(
              child: CircleAvatar(
                  backgroundColor: Colors.deepPurple, maxRadius: 15),
              onTap: () {
                themeService.setTheme(Colors.deepPurple, 'deepPurple');
              },
            ),
            GestureDetector(
              child: CircleAvatar(backgroundColor: Colors.blue, maxRadius: 15),
              onTap: () {
                themeService.setTheme(Colors.blue, 'blue');
              },
            ),
            GestureDetector(
              child: CircleAvatar(backgroundColor: Colors.green, maxRadius: 15),
              onTap: () {
                themeService.setTheme(Colors.green, 'green');
              },
            ),
            GestureDetector(
              child: CircleAvatar(backgroundColor: Colors.red, maxRadius: 15),
              onTap: () {
                themeService.setTheme(Colors.red, 'red');
              },
            ),
          ]),
        )
      ]),
    );
  }
}
