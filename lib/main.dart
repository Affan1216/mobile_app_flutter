import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_part2_ecomarket/firebase_options.dart';
import 'package:mbap_part2_ecomarket/screens/Cartscreen.dart';
import 'package:mbap_part2_ecomarket/screens/MainHomeScreen.dart';
import 'package:mbap_part2_ecomarket/screens/MyProduct_screen.dart';
import 'package:mbap_part2_ecomarket/screens/SearchScreen.dart';
import 'package:mbap_part2_ecomarket/screens/addproduct_screen.dart';
import 'package:mbap_part2_ecomarket/screens/auth_screen.dart';
import 'package:mbap_part2_ecomarket/screens/editproduct_screen.dart';
import 'package:mbap_part2_ecomarket/screens/location.dart';
import 'package:mbap_part2_ecomarket/screens/resetPasswordScreen.dart';
import 'package:mbap_part2_ecomarket/screens/view_myproductscreen.dart';
import 'package:mbap_part2_ecomarket/services/firebase_service.dart';
import 'package:mbap_part2_ecomarket/services/theme_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GetIt.instance.registerLazySingleton(() => FirebaseService());
  GetIt.instance.registerLazySingleton(() => ThemeService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  final ThemeService themeService = GetIt.instance<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: fbService.getAuthUser(),
      builder: (context, snapshot) {
        return StreamBuilder<Color>(
          stream: themeService.getThemeStream(),
          builder: (contextTheme, snapshotTheme) {
            return MaterialApp(
              theme: ThemeData(
                primarySwatch: Colors.green,
                colorScheme: ColorScheme.fromSeed(seedColor: snapshotTheme.data ?? Colors.green),
                useMaterial3: true,
              ),
              home: snapshot.connectionState != ConnectionState.waiting && snapshot.hasData
            ?  MainHomeScreen() : AuthScreen(),
              routes: {
                AddProduct.routeName: (_) {
                  return  AddProduct();
                },
                CartScreen.routeName: (_) {
                  return  CartScreen();
                },
                EditProductScreen.routeName: (_) {
                  return  EditProductScreen();
                },
                MainHomeScreen.routeName: (_) {
                  return  MainHomeScreen();
                },
                MyProductScreen.routeName: (_) {
                  return  MyProductScreen();
                },
                SearchScreen.routeName: (_) {
                  return  SearchScreen();
                },
                ViewProductScreen.routeName: (_) {
                  return  ViewProductScreen();
                },
                AuthScreen.routeName: (_) { 
                  return AuthScreen();
                },
                ResetPasswordScreen.routeName: (_){
                  return ResetPasswordScreen();
                },
                Location.routeName: (_){
                  return Location();
                }
              },
            );
          }
        );
      },
    );
  }
}
